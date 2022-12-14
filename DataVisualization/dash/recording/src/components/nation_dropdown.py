
from typing import List
from dash import Dash, html, dcc 
from dash.dependencies import Input, Output
from . import ids
import pandas as pd


def render(app: Dash, data:pd.DataFrame) -> html.Div:
    all_nations = ["South Korea", "China", "Canada"]
    
    @app.callback(
        Output(ids.NATION_DROPDOWN, "value"),
        Input(ids.SELECT_ALL_NATIONS_BUTTON, "n_clicks")
    )
    def select_all_nations( _ : int) -> List:
        return all_nations
        
    
    return html.Div(
        children=[
            html.H6("nation"),
            dcc.Dropdown(
                id=ids.NATION_DROPDOWN,
                options=[{"label" : nation, "value" : nation} for nation in all_nations],
                value=all_nations,
                multi=True,
            ),
            html.Button(
                className="dropdown-button",
                children=["Select All"],
                id=ids.SELECT_ALL_NATIONS_BUTTON,
            )
        ]
    )