# from dash import Dash, dcc, html 
# import plotly.express as px 
# from . import ids
# from dash.dependencies import Input, Output

# MEDAL_DATA = px.data.medals_long()

# def render(app: Dash) -> html.Div:
#     @app.callback(
#         Output(ids.BAR_CHART, "children"),
#         Input(ids.NATION_DROPDOWN, "value")
#     )
#     def update_bar_chart(nations:list) -> html.Div:
#         filtered_data = MEDAL_DATA.query("nation in @nations")
        
#         if filtered_data.shape[0] == 0:
#             return html.Div("No data Selected.")
#         fig = px.bar(filtered_data, x="medal", y="count", color="nation", text="nation")
#         return html.Div(dcc.Graph(figure=fig), id=ids.BAR_CHART,)
#     return html.Div(id=ids.BAR_CHART)        
    


from typing import List
import pandas as pd
import plotly.express as px
from dash import Dash, dcc, html
from dash.dependencies import Input, Output

from ..data.loader import DataSchema
from . import ids


def render(app: Dash, data: pd.DataFrame) -> html.Div:
    @app.callback(
        Output(ids.BAR_CHART, "children"),
        [
            Input(ids.YEAR_DROPDOWN, "value"),
            Input(ids.MONTH_DROPDOWN, "value"),
            Input(ids.CATEGORY_DROPDOWN, "value"),
        ],
    )
    def update_bar_chart(
        years: List[str], months: List[str], categories: List[str]
    ) -> html.Div:
        filtered_data = data.query(
            "year in @years and month in @months and category in @categories"
        )

        if filtered_data.shape[0] == 0:
            return html.Div("No data selected.", id=ids.BAR_CHART)

        def create_pivot_table() -> pd.DataFrame:
            pt = filtered_data.pivot_table(
                values=DataSchema.AMOUNT,
                index=[DataSchema.CATEGORY],
                aggfunc="sum",
                fill_value=0,
                dropna=False,
            )
            return pt.reset_index().sort_values(DataSchema.AMOUNT, ascending=False)

        fig = px.bar(
            create_pivot_table(),
            x=DataSchema.CATEGORY,
            y=DataSchema.AMOUNT,
            color=DataSchema.CATEGORY,
        )

        return html.Div(dcc.Graph(figure=fig), id=ids.BAR_CHART)

    return html.Div(id=ids.BAR_CHART)