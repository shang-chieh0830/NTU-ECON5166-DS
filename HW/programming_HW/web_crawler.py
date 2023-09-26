import pandas as pd
import requests as rq
from bs4 import BeautifulSoup as bs
from urllib import parse
import re

def get_hotels(location, checkin, checkout, num_results=100):
    string = "https://www.booking.com/searchresults.zh-tw.html?"
    headers = {
        "User-Agent": "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/16.5 Safari/605.1.15"
    }

    # Initialize an empty DataFrame with columns
    columns = ["name", "location", "price", "ratings", "distance", "comments"]
    hotels = pd.DataFrame(columns=columns)

    offset = 0
    while len(hotels) < num_results:
        query = {
            "ss": location,
            "checkin": checkin,
            "checkout": checkout,
            "offset": offset
        }

        
        url = string + parse.urlencode(query)
        #print(f"Currently searching for {url}")
        
        res = rq.get(url, headers=headers)
        #print(f"The status code is {res.status_code}")
        
        soup = bs(res.text, 'html.parser')
        #if offset == 0:
        #    print(soup.select('h1.f6431b446c.d5f78961c3')[0].text.strip())
        
        offset += 25
        
        ratings_data = [rating.text.strip() for rating in soup.select('div.aca0ade214.ebac6e22e9.cd2e7d62b0.f920833fe5')]
        if not ratings_data: #沒資料就break
            break

        # Initialize a new temp DataFrame for each loop iteration
        temp_df = pd.DataFrame(columns=columns)

        # Extract the data from the list and add it to the temp DataFrame
        for item in ratings_data:
            # Use regular expression to extract ratings and comments
            match = re.match(r'(\d\.\d)(\D+)(\d*,?\d+\s則評語).*', item)

            if match:
                rating, comment_text, _ = match.groups()
            else:
                rating = None
                comment_text = None

            # Add a new row to the temp DataFrame
            temp_df.loc[len(temp_df)] = [None, None, None, rating, None, comment_text]

        # Extract other data and update the temp DataFrame accordingly
        temp_df["name"] = [name.text.strip() for name in soup.select('div[data-testid="title"].f6431b446c')]
        temp_df["location"] = [location.text.strip() for location in soup.select('span.f4bd0794db[data-testid="address"]')]
        temp_df["price"] = [price.text.strip() for price in soup.select("span.f6431b446c.fbd1d3018c.e729ed5ab6")]
        if soup.select('span[aria-expanded="false"][data-testid="distance"]'):
            temp_df["distance"] = [distance.text.strip() for distance in soup.select('span[aria-expanded="false"][data-testid="distance"]')]

        # Append temp_df to the main DataFrame hotels_df
        hotels = pd.concat([hotels, temp_df], ignore_index=True)

        if len(hotels) >= num_results:
            break
        
    hotels['price'] = hotels['price'].str.replace('TWD', '').str.replace(',', '').astype(int)
    hotels["ratings"] = hotels["ratings"].astype(float)
    hotels["comments"] = hotels["comments"].astype(str)
    hotels['distance'] = hotels['distance'].apply(lambda x: None if x is None else (float(x.replace('距中心 ', '').split(' ')[0]) / 1000) if '公尺' in x else float(x.replace('距中心 ', '').split(' ')[0]))
    
    return hotels
