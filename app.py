import os
from flask import Flask, request, redirect, url_for, flash, send_from_directory, render_template, jsonify
from werkzeug.utils import secure_filename
from SudokuSolver import SudokuSolver
import matlab.engine
eng = matlab.engine.start_matlab()

UPLOAD_FOLDER = 'static/images'
ALLOWED_EXTENSIONS = set(['png', 'jpg', 'jpeg'])

app = Flask(__name__)
app.secret_key = "super secret key"
app.config['UPLOAD_FOLDER'] = UPLOAD_FOLDER

numSolves = 0
mats = []
solvedSuds = []


def allowed_file(filename):
    return '.' in filename and \
           filename.rsplit('.', 1)[1].lower() in ALLOWED_EXTENSIONS

@app.route('/upload', methods=['GET', 'POST'])
def upload_file():
    if request.method == 'POST':
        global choice
        choice = request.form['photo']
        # check if the post request has the file part
        if 'file' not in request.files:
            flash('No file part')
            return redirect(request.url)
        file = request.files['file']
        # if user does not select file, browser also
        # submit a empty part without filename
        if file.filename == '':
            flash('No selected file')
            return redirect(request.url)
        if file and allowed_file(file.filename):
            filename = secure_filename(file.filename)
            file.save(os.path.join(app.config['UPLOAD_FOLDER'], filename))
            return redirect(url_for('uploaded_file',
                                    filename=filename))
    return '''
    <!doctype html>
    <title>Upload new File</title>
    <h1>Upload your Sudoku</h1>
    <form method=post enctype=multipart/form-data>
      <p><input type=file name=file>
         <input type=submit value=Upload>
         <br>
         <br>
         <h5> Is this picture a photograph or a graphic?</h3>
         <input type="radio" name="photo" value="No"> Graphic<br>
        <input type="radio" name="photo" value="Yes"> Photograph<br>
    </form>
    '''

@app.route('/upload_cropped', methods=['GET', 'POST'])
def upload_cropped_file():
    if request.method == 'POST':
        # check if the post request has the file part
        if 'croppedImage' not in request.files:
            flash('No file part')
            return redirect("http://127.0.0.1:5000")
        file = request.files['croppedImage']
        # if user does not select file, browser also
        # submit a empty part without filename
        if file.filename == '':
            flash('No selected file')
            return redirect("http://127.0.0.1:5000")
        if file :
            filename = secure_filename(file.filename)
            file.save(os.path.join(app.config['UPLOAD_FOLDER'], 'cropped_' + filename ))
            mat = eng.do('static/images/cropped_' + filename, choice)
            mats.append(mat)
            global numSolves
            numSolves = numSolves + 1
            return "ok"

    return "bad request"

@app.route('/refine')
def refine():
	mat = mats[numSolves-1]
	return render_template('mat.html', mat=mat)

@app.route('/getMatrix/<num>')
def getMatrix(num):
	return jsonify(mats[num])



@app.route('/upload_refined/<mat>', methods=['GET', 'POST'])
def upload_refined(mat):
	mat = mat.encode('ascii', 'ignore')
	arr = mat.split(',')
	arr = [int(e) for e in arr]
	sud = [arr[i:i + 9] for i in xrange(0, len(arr), 9)]
	ss = SudokuSolver(sud)
	global solvedSuds
	solvedSuds = ss.main()
	print solvedSuds
	return url_for('solved')

@app.route('/solved')
def solved():
	print solvedSuds
	temp = eng.createCompleteSudoku(solvedSuds, nargout=0)
	return render_template('end.html', mat=solvedSuds)

@app.route('/uploads/<filename>')
def uploaded_file(filename):
    return render_template('cropper.html', filename=filename)

app.run()