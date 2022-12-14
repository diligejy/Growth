import streamlit as st 

# 2. Change Default App Name and Icon
from PIL import Image
img = Image.open("pororo.jpg")
st.set_page_config(page_title="Streamlit Tricks", page_icon=img)

st.header("Cool Streamlit Tricks")

# 1. Create Horizontal Radio Buttons
st.radio(label="Radio Buttons", options=["R1", "R2", "R3", "R4"])
st.write("<style>div.row-widget.stRadio > div{flex-direction:row;}</style>", unsafe_allow_html=True)

# 3. Remove Main Menu and Footer Note
hide_menu_style = """
    <style>
    #MainMenu {visibility: hidden;}
    footer {visibility: hidden;}
    </style>
"""
st.markdown(hide_menu_style, unsafe_allow_html=True)

# Highlighing DataFrame
# def color_df(val):
#     if val > 21:
#         color = "green"
#     else:
#         color = "red"
#     return f'background-color : {color}'

# DataFrame
# df = pd.DataFrame(data, columns=['Name', 'Age'])
# Using Style for the DataFrame 
# st.dataframe(df.style.applymap(color_df, subset=['Age']))


