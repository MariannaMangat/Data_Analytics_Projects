import csv

############### Script works with any of the csv documents (uncomment any file) #############
# filepath = "raw_data/election_data_1.csv"
filepath = "raw_data/election_data_2.csv"

# Read data into dictionary
with open(filepath) as csvfile:
    reader = csv.DictReader(csvfile)

# Set counters
    total_votes = 0
    candidate_names = {}
    name = []
    voted = []
    average_votes = []
    win_count = 0

    for row in reader:
        # 1 Count the total number of votes
        total_votes = total_votes + 1
        candidate = row["Candidate"]

    # 2 Count the total number of votes each candidate won
        if candidate not in candidate_names:
            candidate_names[candidate] = 0
        candidate_names[candidate] = candidate_names[candidate] + 1

    # 3. Count a complete list of candidates who received votes
    # 4. Count the percentage of votes each candidate won
    # 5. Count the total number of votes each candidate won

    for key in candidate_names:
        name.append(key)
        voted.append(candidate_names[key])
        average_votes.append(round((candidate_names[key]/total_votes)*100, 2))

    # 6. Count the winner of the election based on popular vote.
        if candidate_names[key] > win_count:
            win_count = candidate_names[key]
            winner = key
    
# Print the analysis to the terminal
result = ""
for i in range(len(name)):
    result += f"{name[i]}: {average_votes[i]}% ({voted[i]})\n"

output = (
    f"\nElection Results\n"
    f"-----------------------\n"
    f"Total Votes: {str(total_votes)}\n"
    f"-----------------------\n"
    f"{result}"
    f"-----------------------\n"
    f"Winner: {winner}\n"
    f"-----------------------\n"
)

# Print the analysis to the terminal
print(output)

# Export a text file with the results
with open("pypoll_output.txt", "w") as txt:
    txt.write(output)
