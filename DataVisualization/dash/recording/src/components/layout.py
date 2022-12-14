# from dash import Dash, html
# from . import nation_dropdown, bar_chart
# import pandas as pd 

# def create_layout(app: Dash, data: pd.DataFrame) -> html.Div:
#     return html.Div(
#         className="app-div",
#         children=[
#             html.H1(app.title),
#             html.Hr(),
#             html.Div(
#                 className="dropdown-container",
#                 children=[
#                     nation_dropdown.render(app, data)
#                 ]
#             ),
#             bar_chart.render(app)
#         ]
#     )

import pandas as pd
from dash import Dash, html
from src.components import (
    bar_chart,
    category_dropdown,
    month_dropdown,
    pie_chart,
    year_dropdown,
)


def create_layout(app: Dash, data: pd.DataFrame) -> html.Div:
    return html.Div(
        className="app-div",
        children=[
            html.H1(app.title),
            html.Hr(),
            html.Div(
                className="dropdown-container",
                children=[
                    year_dropdown.render(app, data),
                    month_dropdown.render(app, data),
                    category_dropdown.render(app, data),
                ],
            ),
            bar_chart.render(app, data),
            pie_chart.render(app, data),
        ],
    )