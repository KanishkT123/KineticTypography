from wtforms import Form, TextField, TextAreaField, validators, StringField, SubmitField, BooleanField
from wtforms.validators import DataRequired


class InputForm(Form):
    inputString = StringField('inputString', validators=[DataRequired()])
    remember_me = BooleanField('remember_me', default=False)
