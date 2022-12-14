import yfinance as yf
import streamlit as st
import pandas as pd

st.write(
    """
# Simple Stock Price App

Shown are the stock closing price and volume of Google!

"""
)

tickerSymbols = ["AAPL", "GOOGL"]

with st.form("line_chart"):
    selected_tickerSymbol = st.selectbox(label="tickerSymbol", options=tickerSymbols)
    submitted = st.form_submit_button("Submit")
    # tickerSymbol = "GOOGL"
    if submitted:
        tickerData = yf.Ticker(selected_tickerSymbol)

        tickerDf = tickerData.history(period="1d", start="2010-05-31", end="2020-05-31")
        st.write(
            """
            ## Closing Price
            """
        )
        st.line_chart(tickerDf.Close)
        st.write(
            """
        ## Volume Price
        """
        )
        st.line_chart(tickerDf.Volume)

with st.sidebar:
    st.subheader("About")
    st.markdown("This dashboard is made by Jinyoung")
