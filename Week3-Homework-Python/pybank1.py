import os
import csv

############### Script works with any of the csv documents (uncomment any file) #############
# filepath = os.path.join("raw_data", "budget_data_1.csv")
filepath = os.path.join("raw_data", "budget_data_2.csv")

# Read data into dictionary 
with open(filepath) as csvfile:
    reader = csv.DictReader(csvfile)

# Set counters 
    months_revenue_data = 0
    total_revenue = 0
    average_revenue = 0
    min_increase = 0
    total_list = []
    date_list = []

    for row in reader:
        
# 1. Count Total Months
        months_revenue_data = months_revenue_data + 1

# 2. Count Total Revenue:
        total_revenue = total_revenue + int(row["Revenue"])

# 3. Count Average Revenue Change
        average_revenue = total_revenue / months_revenue_data

# 4. Count Greatest Increase in Revenue
        total_list.append(int(row["Revenue"])) 
        date_list.append(row["Date"])
index_max = total_list.index(max(total_list))

# 5. Count Greatest Decrease in Revenue
index_min = total_list.index(min(total_list))

output = (
    f"\nFinancial Analysis\n"
    f"---------------\n"
    f"Total Months: {str(months_revenue_data)}\n"
    f"Total Revenue: ${str(total_revenue)}\n"
    f"Average Revenue Change: ${str(int(average_revenue))}\n"
    f"Greatest Increase in Revenue: {date_list[index_max]} (${str(max(total_list))})\n"
    f"Greatest Decrease in Revenue: {date_list[index_min]} (${str(min(total_list))})\n"
)
# Print the analysis to the terminal
print(output)

# Export a text file with the results
with open("pybank_output.txt", "w") as txt:
    txt.write(output)

