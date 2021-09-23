#!pip install SpeechRecognition
#!pip install pipwin
#!pipwin install pyaudio
#!pip install googletrans==3.1.0a0

import speech_recognition as sr
import pyodbc
from googletrans import Translator

def main():
    r = sr.Recognizer()
    
    with sr.Microphone() as source:
        r.adjust_for_ambient_noise(source)
        
        print("Lan hadii söyleee")
        
        audio = r.listen(source)
        
        try:
            return r.recognize_google(audio, language="tr-TR")
            #print("Bing Perception:" + r.recognize_bing(audio))
            #print("Google Cloud Perception: \n" + r.recognize_google_cloud(audio))
            #print("Houndify Perception: \n" + r.recognize_houndify(audio))
            #print("IBM Perception: \n" + r.recognize_ibm(audio))
            #print("Sphinx Perception: \n" + r.recognize_sphinx(audio))
            #print("Wit Perception: \n" + r.recognize_wit(audio))
        except Exception as e:
            print("Error : " + str(e))
            
if __name__ == "__main__":
        translator = Translator()
        memet = main()
        print("Google Perception:" + memet)
        memet2 = translator.translate(memet, dest='en', src='tr').text
        connect = pyodbc.connect('DRIVER={SQL SERVER};SERVER=localhost;DATABASE=MyDatabase2;Trusted_Connection=yes')
        cursor = connect.cursor()
        cursor.execute('EXEC TEXT_ATAYICI \'{0}\'')
        connect.commit()