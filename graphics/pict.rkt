#lang racket
(require racket/gui/base pict)

; Main frame
(define f
  (new frame%
    [label "Circle"] [width 640] [height 480]))

; Arrow constants
(define arrow-size 60)
(define arrow-color "firebrick")

; Number of ellipses on one side
(define num-ellipses 5)

; Ellipse colors
(define colors '("gold" "purple"))

; Gold or purple ellipse
(define (random-ellipse i)
  (filled-ellipse (* i 8)
                  (* i 35)
                  #:color ((if (even? i) first second) colors)))

; Ellipses of increasing sizes
(define (make-ellipses c)
  (if (zero? c) (blank)
      (hc-append (random-ellipse c)
                 (make-ellipses (sub1 c)))))

; Ellipses of decreasing sizes
(define (make-rev-ellipses c)
  (let h ((c c) (s 1))
    (if (zero? c) (blank)
        (hc-append (random-ellipse s)
                   (h (sub1 c) (add1 s))))))

; Disk
(define (cdsk s c)
  (disk s #:color c))

; Rounded rectangle
(define (frsq s c)
  (filled-rounded-rectangle s s #:color c))

; Canvas
(define c
  (new canvas%
    (parent f)
    (paint-callback
      (λ (c dc)
        (draw-pict

          ; Arrow above ellipses
          (let ((left (vc-append (colorize (arrowhead arrow-size (* 1.5 pi))
                                           arrow-color)
                                 (make-rev-ellipses num-ellipses)))

                ; Ellipses above arrow
                (right (vc-append (make-ellipses num-ellipses)
                                  (colorize (arrowhead arrow-size (/ pi 2))
                                            arrow-color)))

                ; Circles above rounded rectangles
                (center (let* ((l 100) (s 50) (f 3) (sf (/ s f)))
                          (vc-append (cc-superimpose
                                       (cdsk l "red")
                                       (cdsk s "blue")
                                       (cdsk sf "yellow"))
                                     (cc-superimpose
                                       (frsq l "orange")
                                       (frsq s "black")
                                       (frsq sf "red"))
                                       (text "Pict" null 60)))))

            ; Combine image parts on background
            (cc-superimpose (filled-rounded-rectangle 380 280 #:color "pale green")
                            (hc-append 10 left center right))) dc 100 10)))))

; Show image
(send f show #t)

