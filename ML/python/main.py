import pandas as pd
from sklearn.linear_model import LogisticRegression
from sklearn.model_selection import train_test_split
from sklearn.feature_extraction.text import TfidfVectorizer
import re
import contractions
from google import genai

people_emotion = "I am happy today because i get full mark in my final exam"

def main() :

    df_np = pd.read_csv("../csv_file/training_1600000_processed_noemoticon.csv", header=None, encoding="latin-1") # read negative/positive file
    df_np.columns = ["target", "id", "date", "flag", "user", "text"]
    df_personal = pd.read_csv("../csv_file/labeled_data.csv") #read personal/nonpersonal file

    def clean_text(text) :
        text = text.lower()

        text = re.sub(r'[^A-Za-z\s]', '', text)

        text = re.sub(r'http\S+', '', text)

        text = re.sub(r'\s+', ' ', text).strip()

        text = re.sub(r'@\w+', '', text)

        return text
    
    def expand_contractions(text) :
        return contractions.fix(text)
    
    def remove_extra_space(text) :
        return ' '.join(text.split())

    def negative_positive () :

        vectorizer = TfidfVectorizer()

        X = vectorizer.fit_transform(df_np["text"].apply(clean_text).apply(expand_contractions).apply(remove_extra_space)) 
        y = df_np["target"]

        X_test, X_train, y_test, y_train = train_test_split(X, y, random_state=42, test_size=0.2)

        model = LogisticRegression(max_iter=1000)
        model.fit(X_train, y_train)

        predict = model.predict(vectorizer.transform([people_emotion]))

        if predict[0] == 4 :
            return True
        else :
            return False

    def personal_nonpersonal () :

        vectorizer = TfidfVectorizer(ngram_range=(1, 2))

        X = vectorizer.fit_transform(df_personal["tweet"].apply(clean_text).apply(expand_contractions).apply(remove_extra_space))
        y = df_personal["class"] 

        X_train, X_text, y_train, y_test = train_test_split(X, y, random_state=42, test_size=0.2)

        model = LogisticRegression(max_iter=5000, class_weight="balanced")
        model.fit(X_train, y_train)

        predict = model.predict(vectorizer.transform([people_emotion]))

        if predict[0] == 0 or predict[0] == 1 :
            return True
        else :
            return False
    
    def advice() :
        client = genai.Client()

        response = client.models.generate_content(
            model="gemini-3-flash-preview",
            contents=f"Give an advice to this person about {people_emotion}",
        )

        print(response.text)

    def congrats():
        client = genai.Client()

        response = client.models.generate_content(
            model="gemini-3-flash-preview",
            contents=f"Give a congrats massage to this guy about {people_emotion}",
        )

        print(response.text)

    if negative_positive() :
        print("Positive")
        congrats()
    else :
        if personal_nonpersonal() :
            print("Negative, Personal")
        else :
            print("Negative, Non - Personal")
            advice()
    

if __name__ == "__main__" :
    main()