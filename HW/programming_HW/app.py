import dash
import dash_core_components as dcc
import dash_html_components as html
from dash.dependencies import Input, Output
import web_crawler  # Import my web crawler function
import plotly.express as px
from datetime import datetime

app = dash.Dash(__name__)

app.layout = html.Div([
    html.H1(children='Hotel Data Dashboard', style={
    'textAlign': 'center',
    'color': '#BBDFGT',
    'margin': '20px 0'  # Adds top and bottom margin
    }),

    
    dcc.Markdown("A simple dashboard for hotels data from [booking.com](https://www.booking.com/)",
                     style={
                         "textAlign": "center"
                     }
    ),

    html.Div([
        dcc.Markdown('Location:'),
        dcc.Input(id='location-input', type='text', placeholder='Enter location', style={
            'border': '1px solid #ccc',
            'padding': '15px',
            'boxShadow': '1px 1px 3px rgba(0,0,0,0.1)'
        }),
    ]),

    html.Div([
        dcc.Markdown('Pick Check-in and Check-out Date:'),
        dcc.DatePickerRange(
            id='date-picker',
            start_date=datetime.now().strftime('%Y-%m-%d'),
            end_date=None,  # Set end_date to None initially
            display_format='YYYY-MM-DD'
        ),
    ]),

    html.Button('Fetch Hotel Data', id='fetch-button', style={
    'backgroundColor': '#0074D9',
    'color': 'white',
    'border': 'none',
    'padding': '10px 20px',
    'borderRadius': '5px',
    'cursor': 'pointer'
    }),


    dcc.Loading(id="loading", children=[
        dcc.Graph(id="scatter-plot"),
    ])
]) 

@app.callback(
    Output("scatter-plot", "figure"),
    Input("fetch-button", "n_clicks"),
    Input("location-input", "value"),
    Input("date-picker", "start_date"),
    Input("date-picker", "end_date"),
)
def update_hotel_data(n_clicks, location, start_date, end_date):
    if n_clicks is None:
        return {}

    # Handle the case where end_date is None (not selected)
    if end_date is None:
        end_date = datetime.now().strftime('%Y-%m-%d')

    # Call your web crawler function with user inputs
    hotels = web_crawler.get_hotels(location, start_date, end_date)

    # Create the scatter plot using Plotly Express
    fig = px.scatter(hotels, x='price', y='distance', color='ratings',
                     hover_name='name',
                     hover_data={'price': True, 'ratings': True})

    # Customize the plot
    fig.update_traces(marker=dict(size=12, opacity=0.7),
                      selector=dict(mode='markers+text'))

    # Add titles and labels
    fig.update_layout(
        title='Hotel Prices vs. Distance from Center',
        xaxis_title='Price',
        yaxis_title='Distance from Center (kilometers)'
    )

    return fig

if __name__ == '__main__':
    app.run_server(debug=True)

