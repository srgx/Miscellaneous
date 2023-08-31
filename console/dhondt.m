
#
# D'Hondt method
#

# Number of seats
nMandates = 8;

# Votes for parties
votes = [720 300 480];

# Number of parties
nParties = length(votes);

# Successive quotients
quotients = {};

# Divisors
for i = 1:nMandates

  # Collect quotients
  for j = 1:nParties
    quotients(end + 1, :) = {votes(j) / i j};
  endfor

endfor

# Sort and display quotients
quotients = sortrows(quotients, -1)

# Assign seats to parties
mandates = zeros(1, length(votes));
for i = 1:nMandates
  mandates(quotients{i, 2}) += 1;
endfor

# Result
mandates

