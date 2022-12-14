from pathlib import Path
import profile 
import streamlit as st 
from PIL import Image

#  --- Path Settings --- 
current_dir = Path(__file__) if "__file__" in locals() else Path.cwd()
css_file = current_dir / "styles" / "main.css"
resume_file = current_dir / "assets" / "Jinyoung_Song.pdf"
profile_pic = current_dir / "assets" / "pororo.png"

# --- General Settings --- 
PAGE_TITLE = "Digital CV / Jinyoung Song"
PAGE_ICON = ":wave:"
NAME = "Jinyoung Song"
DESCRIPTION = """
Product Data Analyst, assisting enterprises by supporting data-driven decision-making.
"""
EMAIL = "sjy049@gmail.com"
SOCIAL_MEDIA = {
    "LinkedIn" : "https://www.linkedin.com/in/jinyoung-song-76731516b/",
    "GitHub" : "https://github.com/diligejy",
    "Blog" : "https://ugong2san.tistory.com"
}

st.set_page_config(page_title=PAGE_TITLE, page_icon=PAGE_ICON)


st.title("Hello there!")

# --- LOAD CSS, PDF & Profile PIC --- 
with open(css_file) as f:
    st.markdown("<style>{}</style>".format(f.read()), unsafe_allow_html=True)
    
with open(resume_file) as pdf_file:
    PDFbyte = pdf_file.read()

profile_pic = Image.open(profile_pic)

# --- Hero Section --- 
col1, col2 = st.columns(2, gap="small")
with col1:
    st.image(profile_pic, width=230)
    st.write(DESCRIPTION)
    st.download_button(
        label="Download Resume",
        data=PDFbyte,
        file_name = resume_file.name,
        mime = "application/octet-stream"
    )
    

with col2:
    st.title(NAME)
    st.write(DESCRIPTION)
    st.download_button(
        label=" 📄 Download Resume",
        data=PDFbyte,
        file_name=resume_file.name,
        mime="application/octet-stream",
    )
    st.write("📫", EMAIL)


# --- SOCIAL LINKS ---
st.write("#")
cols = st.columns(len(SOCIAL_MEDIA))
for index, (platform, link) in enumerate(SOCIAL_MEDIA.items()):
    cols[index].write(f"[{platform}]({link})")


# --- EXPERIENCE & QUALIFICATIONS ---
st.write("#")
st.subheader("Experience & Qulifications")
st.write(
    """
- ✔️ Strong hands on experience and knowledge in Python and SQL
- ✔️ Good at Logical Thinking 
- ✔️ Excellent team-player and displaying strong sense of initiative on tasks
"""
)


# --- SKILLS ---
st.write("#")
st.subheader("Hard Skills")
st.write(
    """
- 👩‍💻 Programming: Python (Scikit-learn, Pandas), SQL
- 📊 Data Visulization: Streamlit, Plotly, Tableau
- 📚 Modeling: Logistic regression, linear regression, decition trees
- 🗄️ Databases: Postgres, MongoDB, MySQL
"""
)


# --- WORK HISTORY ---
st.write("#")
st.subheader("Work History")
st.write("---")

# --- JOB 1
st.write("🚧", "**Data Analyst | BigInsight**")
st.write("08/2021 - 08/2022")
st.write(
    """
- ► Redesigned UI/UX KAKAO Biz linkage with cross-functinoal teams to achieve a 80% jump in linkage success rate
"""
)

