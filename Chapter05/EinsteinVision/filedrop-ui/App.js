import React, { Component } from 'react';
import logo from './logo.svg';
import './App.css';
import Dropzone from 'react-dropzone';
import superagent from 'superagent';
import Results from './results';

class App extends Component {

  state = {
    files: [],
    uploadResponse: null,
    uploadError: null
  }

  onDrop = (files) => {
      console.log('Received files: ', files);
      this.setState({
        files: files
      });
      var req = superagent.post('/file-upload');
       files.forEach((file)=> {
        // Backend expects 'file' reference
        req.attach('file', file, file.name);
      });
      req.end((err,res) => {
        this.setState({ isProcessing: false });
        if (err) {
          console.log('file-upload error', err);
          this.setState({ uploadError: err.message });
          return;
        }
        console.log('file-upload response', res);
        this.setState({ uploadResponse: JSON.parse(res.text) });
      });
    }

  render() {
    return (
     <div className="slds">
       <div className="slds-form-element">
        <span className="slds-form-element__label" id="file-selector-id">Attachment</span>
        <div className="slds-form-element__control">
          <div className="slds-file-selector slds-file-selector--images">
            <Dropzone onDrop={this.onDrop} className="slds-file-selector__dropzone wrap">
            <div >Try dropping some files here, or click to select files to upload.</div>
            </Dropzone>
            <span>
            {this.state.files.length > 0 ? 
            <div>
                <h2>Uploading {this.state.files.length} files...</h2>
                <div>{this.state.files.map((file) => <img src={file.preview} /> )}</div>
            </div>
             : null}
             {this.state.uploadResponse != null ?
              <Results results={this.state.uploadResponse.probabilities}/>
              : null}
              </span>
            </div>
          </div>
        </div>
      </div>
    );
  }
}

export default App;
