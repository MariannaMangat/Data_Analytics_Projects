
# Heroes Of Pymoli Data Analysis

* Considering that total amount of players is 573 and total amount of purchases is 780, we can see that game produces a good amount of repetitive purchases.


* A demographic range of 20-24 years brings the most profit overall by the highest amount of players. But an average purchase of this age category is under 3 dollars, where age categories 30-34 and 40+ are willing to spend above 3 dollars on average.


* Gender group "Other / Non-Disclosed" had the highest purchase amount on average, even thought this group is only 1% out of all players.


* Top 4 out of 5 most popular items that were purchased cost around 2 dollars. But item "Retribution Axe" is well above 4 dollars, and it brought the most revenue of 37.26 dollars. This tells about an importance of this item's value which should be considered while improving and upgrading the game. 


```python
# Import dependencies
import pandas as pd

# Read json file
json_path = 'purchase_data.json'
game_data = pd.read_json(json_path, orient="records")
game_data.head()
```

<!-- <div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }
</style> -->

<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>Age</th>
      <th>Gender</th>
      <th>Item ID</th>
      <th>Item Name</th>
      <th>Price</th>
      <th>SN</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>38</td>
      <td>Male</td>
      <td>165</td>
      <td>Bone Crushing Silver Skewer</td>
      <td>3.37</td>
      <td>Aelalis34</td>
    </tr>
    <tr>
      <th>1</th>
      <td>21</td>
      <td>Male</td>
      <td>119</td>
      <td>Stormbringer, Dark Blade of Ending Misery</td>
      <td>2.32</td>
      <td>Eolo46</td>
    </tr>
    <tr>
      <th>2</th>
      <td>34</td>
      <td>Male</td>
      <td>174</td>
      <td>Primitive Blade</td>
      <td>2.46</td>
      <td>Assastnya25</td>
    </tr>
    <tr>
      <th>3</th>
      <td>21</td>
      <td>Male</td>
      <td>92</td>
      <td>Final Critic</td>
      <td>1.36</td>
      <td>Pheusrical25</td>
    </tr>
    <tr>
      <th>4</th>
      <td>23</td>
      <td>Male</td>
      <td>63</td>
      <td>Stormfury Mace</td>
      <td>1.27</td>
      <td>Aela59</td>
    </tr>
  </tbody>
</table>
</div>



## Player Count


```python
# Separate unique players 
players_breakdown = game_data[["Gender", "SN", "Age"]]
players_breakdown = players_breakdown.drop_duplicates()

# Count a total of players
total_players = players_breakdown["SN"].count()

# Display a total of players
pd.DataFrame({"Total Players": [total_players]})
```




<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>Total Players</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>573</td>
    </tr>
  </tbody>
</table>
</div>



## Purchasing Analysis (Total)


```python
# Count total revenue, purchse, and average price of unique items
unique_items = len(game_data["Item ID"].unique()) 
avg_price = game_data["Price"].mean()
total_purchase = game_data["SN"].count()
total_revenue = game_data["Price"].sum()

# Set a dataframe
df = pd.DataFrame({"Number of Unique Items": [unique_items],
                    "Average Price": [avg_price],
                    "Number of Purchases": [total_purchase],
                    "Total Revenue": [total_revenue]})

purchase_df = df[['Number of Unique Items','Average Price','Number of Purchases','Total Revenue']]

# Format results 
purchase_df["Average Price"] = purchase_df["Average Price"].map("${:.2f}".format)
purchase_df["Total Revenue"] = purchase_df["Total Revenue"].map("${:,.2f}".format)

purchase_df

```




<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>Number of Unique Items</th>
      <th>Average Price</th>
      <th>Number of Purchases</th>
      <th>Total Revenue</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>183</td>
      <td>$2.93</td>
      <td>780</td>
      <td>$2,286.33</td>
    </tr>
  </tbody>
</table>
</div>



## Gender Demographics


```python
# Count a total amount players' gender and percentage
total_gender = pd.DataFrame(players_breakdown['Gender'].value_counts())
percent_gender =(total_gender / game_data['Gender'].count())*100
gender_df = pd.DataFrame(percent_gender)
gender_df["Total"] = total_gender

# Set a dataframe
gender_demogr = gender_df.rename(columns={'Gender':'Percentage of Players',
                                         'Total': 'Total Count'})
# Format results
gender_demogr['Percentage of Players'] = gender_demogr['Percentage of Players'].map("{:.2f}".format)
gender_demogr
```

<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>Percentage of Players</th>
      <th>Total Count</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>Male</th>
      <td>59.62</td>
      <td>465</td>
    </tr>
    <tr>
      <th>Female</th>
      <td>12.82</td>
      <td>100</td>
    </tr>
    <tr>
      <th>Other / Non-Disclosed</th>
      <td>1.03</td>
      <td>8</td>
    </tr>
  </tbody>
</table>
</div>


## Purchasing Analysis (Gender)

```python
# Count an amount of purchases, average purchase, and total value by gender
gender_sales = pd.DataFrame({"Purchase Count": game_data.groupby(["Gender"]).count()["Price"],
                            "Average Purchase Price": game_data.groupby(["Gender"]).mean()["Price"],
                            "Total Purchase Value": game_data.groupby(["Gender"]).sum()["Price"],
                            "Normalized Totals": game_data.groupby(["Gender"]).sum()["Price"] / gender_demogr["Total Count"]})
# Format results
gender_sales["Total Purchase Value"] = gender_sales["Total Purchase Value"].map("${:,.2f}".format)
gender_sales["Average Purchase Price"] = gender_sales["Average Purchase Price"].map("${:,.2f}".format)
gender_sales["Purchase Count"] = gender_sales["Purchase Count"].map("{:,}".format)
gender_sales["Normalized Totals"] = gender_sales["Normalized Totals"].map("${:,.2f}".format)

# Change order of the dataframe
gender_sales = gender_sales[["Purchase Count", "Average Purchase Price", "Total Purchase Value", "Normalized Totals"]]

# Round the results
gender_sales= gender_sales.round(2)
gender_sales

```




<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>Purchase Count</th>
      <th>Average Purchase Price</th>
      <th>Total Purchase Value</th>
      <th>Normalized Totals</th>
    </tr>
    <tr>
      <th>Gender</th>
      <th></th>
      <th></th>
      <th></th>
      <th></th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>Female</th>
      <td>136</td>
      <td>$2.82</td>
      <td>$382.91</td>
      <td>$3.83</td>
    </tr>
    <tr>
      <th>Male</th>
      <td>633</td>
      <td>$2.95</td>
      <td>$1,867.68</td>
      <td>$4.02</td>
    </tr>
    <tr>
      <th>Other / Non-Disclosed</th>
      <td>11</td>
      <td>$3.25</td>
      <td>$35.74</td>
      <td>$4.47</td>
    </tr>
  </tbody>
</table>
</div>



## Age Demographics


```python
# Creat categories of age
age_bins = [0, 9.90, 14.90, 19.90, 24.90, 29.90, 34.90, 39.90, 99999]
name_groups = ["<10", "10-14", "15-19", "20-24", "25-29", "30-34", "35-39", "40+"]

# Connect age categories and labels
age_demogr = players_breakdown.loc[:,["Age"]]
age_demogr["Age Ranges"] = pd.cut(age_demogr["Age"], bins=age_bins, labels=name_groups)

# Count percentage of players by age categories
age_demogr_total = age_demogr["Age Ranges"].value_counts()                               
age_demogr_percent = (age_demogr_total / total_players) * 100

# Display a dataframe
age_ranges = pd.DataFrame({"Total Count": age_demogr_total.round(2), 
                           "Percentage of Players": age_demogr_percent.round(2)})
age_ranges.sort_index()


```




<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>Percentage of Players</th>
      <th>Total Count</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>&lt;10</th>
      <td>3.32</td>
      <td>19</td>
    </tr>
    <tr>
      <th>10-14</th>
      <td>4.01</td>
      <td>23</td>
    </tr>
    <tr>
      <th>15-19</th>
      <td>17.45</td>
      <td>100</td>
    </tr>
    <tr>
      <th>20-24</th>
      <td>45.20</td>
      <td>259</td>
    </tr>
    <tr>
      <th>25-29</th>
      <td>15.18</td>
      <td>87</td>
    </tr>
    <tr>
      <th>30-34</th>
      <td>8.20</td>
      <td>47</td>
    </tr>
    <tr>
      <th>35-39</th>
      <td>4.71</td>
      <td>27</td>
    </tr>
    <tr>
      <th>40+</th>
      <td>1.92</td>
      <td>11</td>
    </tr>
  </tbody>
</table>
</div>



## Purchasing Analysis (Age)


```python
# Add column of age range to the original datafrane
game_data["Age Range"] = pd.cut(game_data["Age"], bins=age_bins, labels=name_groups)

# Count an amount of purchases, average purchase, and total value by age
age_data = pd.DataFrame({ "Total Purchase Value": game_data.groupby(["Age Range"]).sum()["Price"],
                    "Purchase Count": game_data.groupby(["Age Range"]).count()["Price"],
                    "Average Purchase Price": game_data.groupby(["Age Range"]).mean()["Price"],
                    "Normalized Totals": game_data.groupby(["Age Range"]).sum()["Price"] / age_ranges["Total Count"]})
# Rearrange columns
age_data = age_data[["Purchase Count", "Average Purchase Price", "Total Purchase Value", "Normalized Totals"]]

# Format results
age_data["Average Purchase Price"] = age_data["Average Purchase Price"].map("${:,.2f}".format)
age_data["Total Purchase Value"] = age_data["Total Purchase Value"].map("${:,.2f}".format)
age_data ["Purchase Count"] = age_data["Purchase Count"].map("{:,}".format)
age_data["Normalized Totals"] = age_data["Normalized Totals"].map("${:,.2f}".format)

age_data
 
```




<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>Purchase Count</th>
      <th>Average Purchase Price</th>
      <th>Total Purchase Value</th>
      <th>Normalized Totals</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>10-14</th>
      <td>35</td>
      <td>$2.77</td>
      <td>$96.95</td>
      <td>$4.22</td>
    </tr>
    <tr>
      <th>15-19</th>
      <td>133</td>
      <td>$2.91</td>
      <td>$386.42</td>
      <td>$3.86</td>
    </tr>
    <tr>
      <th>20-24</th>
      <td>336</td>
      <td>$2.91</td>
      <td>$978.77</td>
      <td>$3.78</td>
    </tr>
    <tr>
      <th>25-29</th>
      <td>125</td>
      <td>$2.96</td>
      <td>$370.33</td>
      <td>$4.26</td>
    </tr>
    <tr>
      <th>30-34</th>
      <td>64</td>
      <td>$3.08</td>
      <td>$197.25</td>
      <td>$4.20</td>
    </tr>
    <tr>
      <th>35-39</th>
      <td>42</td>
      <td>$2.84</td>
      <td>$119.40</td>
      <td>$4.42</td>
    </tr>
    <tr>
      <th>40+</th>
      <td>17</td>
      <td>$3.16</td>
      <td>$53.75</td>
      <td>$4.89</td>
    </tr>
    <tr>
      <th>&lt;10</th>
      <td>28</td>
      <td>$2.98</td>
      <td>$83.46</td>
      <td>$4.39</td>
    </tr>
  </tbody>
</table>
</div>



## Top Spenders


```python
# Count total and average purchases by indiviual players
buyer_data = pd.DataFrame({"Total Purchase Value": game_data.groupby(["SN"]).sum()["Price"],
                            "Purchase Count": game_data.groupby(["SN"]).count()["Price"],
                            "Average Purchase Price": game_data.groupby(["SN"]).mean()["Price"]})
# Rearrange dataframe
buyer_data = buyer_data[["Purchase Count", "Average Purchase Price", "Total Purchase Value"]]

# Format results
buyer_data["Average Purchase Price"] = buyer_data["Average Purchase Price"].map("${:,.2f}".format)
buyer_data["Total Purchase Value"] = buyer_data["Total Purchase Value"].map("${:,.2f}".format)

# Sort results by total purchase
buyer_data.sort_values("Total Purchase Value", ascending=False).head(5)
```




<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>Purchase Count</th>
      <th>Average Purchase Price</th>
      <th>Total Purchase Value</th>
    </tr>
    <tr>
      <th>SN</th>
      <th></th>
      <th></th>
      <th></th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>Qarwen67</th>
      <td>4</td>
      <td>$2.49</td>
      <td>$9.97</td>
    </tr>
    <tr>
      <th>Sondim43</th>
      <td>3</td>
      <td>$3.13</td>
      <td>$9.38</td>
    </tr>
    <tr>
      <th>Tillyrin30</th>
      <td>3</td>
      <td>$3.06</td>
      <td>$9.19</td>
    </tr>
    <tr>
      <th>Lisistaya47</th>
      <td>3</td>
      <td>$3.06</td>
      <td>$9.19</td>
    </tr>
    <tr>
      <th>Tyisriphos58</th>
      <td>2</td>
      <td>$4.59</td>
      <td>$9.18</td>
    </tr>
  </tbody>
</table>
</div>



## Most Popular Items


```python
# Create set of data based on information about game items
item_purchase = game_data[["Item ID", "Item Name", "Price"]]

# Count an amount of purchases, average purchase, and total value of purchases by items
item_df = pd.DataFrame({"Total Purchase Value": game_data.groupby(["Item ID", "Item Name"]).sum()["Price"], 
                        "Item Price": game_data.groupby(["Item ID", "Item Name"]).mean()["Price"], 
                        "Purchase Count": game_data.groupby(["Item ID", "Item Name"]).count()["Price"]})
# Rearrange dataframe
item_df = item_df[["Purchase Count", "Item Price", "Total Purchase Value"]]

# Format results
item_df["Item Price"] = item_df["Item Price"].map("${:,.2f}".format)
item_df["Purchase Count"] = item_df["Purchase Count"].map("{:,}".format)
item_df["Total Purchase Value"] = item_df["Total Purchase Value"].map("${:,.2f}".format)

# Sort by count of purchses
item_df.sort_values("Purchase Count", ascending=False).head()
```




<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th></th>
      <th>Purchase Count</th>
      <th>Item Price</th>
      <th>Total Purchase Value</th>
    </tr>
    <tr>
      <th>Item ID</th>
      <th>Item Name</th>
      <th></th>
      <th></th>
      <th></th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>13</th>
      <th>Serenity</th>
      <td>9</td>
      <td>$1.49</td>
      <td>$13.41</td>
    </tr>
    <tr>
      <th>34</th>
      <th>Retribution Axe</th>
      <td>9</td>
      <td>$4.14</td>
      <td>$37.26</td>
    </tr>
    <tr>
      <th>175</th>
      <th>Woeful Adamantite Claymore</th>
      <td>9</td>
      <td>$1.24</td>
      <td>$11.16</td>
    </tr>
    <tr>
      <th>31</th>
      <th>Trickster</th>
      <td>9</td>
      <td>$2.07</td>
      <td>$18.63</td>
    </tr>
    <tr>
      <th>106</th>
      <th>Crying Steel Sickle</th>
      <td>8</td>
      <td>$2.29</td>
      <td>$18.32</td>
    </tr>
  </tbody>
</table>
</div>



## Most Profitable Items


```python
# Sort by total purchase value
item_df.sort_values("Total Purchase Value", ascending=False).head()
```




<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th></th>
      <th>Purchase Count</th>
      <th>Item Price</th>
      <th>Total Purchase Value</th>
    </tr>
    <tr>
      <th>Item ID</th>
      <th>Item Name</th>
      <th></th>
      <th></th>
      <th></th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>170</th>
      <th>Shadowsteel</th>
      <td>5</td>
      <td>$1.98</td>
      <td>$9.90</td>
    </tr>
    <tr>
      <th>21</th>
      <th>Souleater</th>
      <td>3</td>
      <td>$3.27</td>
      <td>$9.81</td>
    </tr>
    <tr>
      <th>37</th>
      <th>Shadow Strike, Glory of Ending Hope</th>
      <td>5</td>
      <td>$1.93</td>
      <td>$9.65</td>
    </tr>
    <tr>
      <th>127</th>
      <th>Heartseeker, Reaver of Souls</th>
      <td>3</td>
      <td>$3.21</td>
      <td>$9.63</td>
    </tr>
    <tr>
      <th>120</th>
      <th>Agatha</th>
      <td>5</td>
      <td>$1.91</td>
      <td>$9.55</td>
    </tr>
  </tbody>
</table>
</div>


