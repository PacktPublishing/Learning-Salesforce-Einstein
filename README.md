# Learning-Salesforce-Einstein
This is the code repository for [Learning Salesforce Einstein](https://www.packtpub.com/big-data-and-business-intelligence/learning-salesforce-einstein?utm_source=github&utm_medium=repository&utm_content=9781787126893), published by [Packt](https://www.packtpub.com/?utm_source=github). It contains all the supporting project files necessary to work through the book from start to finish.

## About the Book
This book is intended for experienced Salesforce developers and data scientists interested in exploring the breadth of Salesforce App Cloud offerings. This book assumes that the reader is familiar with programming, either as an open source developer or a Salesforce developer. All the code files are present in their respective code folders. Chapters 2, 7, 8 and 9 do not have any code files.

## Instructions and Navigation
The code for Chapter 05 is organized into one folder, Chapter05 and the rest in one separate folder.

The code will look like the following:

    var express = require('express');
    var router = express.Router();
    router.get('/', function(req, res) {
      res.render('pages/home', {
        oauthtoken: req.app.locals.oauthtoken
      });
    });
      module.exports = router;


 ## Related Products
* [Learning Salesforce Visual Workflow and Process Builder - Second Edition](https://www.packtpub.com/application-development/learning-salesforce-visual-workflow-and-process-builder-second-edition?utm_source=github&utm_medium=repository&utm_content=9781787284999)

* [Salesforce CRM - The Definitive Admin Handbook - Fourth Edition](https://www.packtpub.com/big-data-and-business-intelligence/salesforce-crm-definitive-admin-handbook-fourth-edition?utm_source=github&utm_medium=repository&utm_content=9781786468963)

* [Salesforce CRM: The Definitive Admin [Video]](https://www.packtpub.com/application-development/salesforce-crm-definitive-admin-video?utm_source=github&utm_medium=repository&utm_content=9781782170761)

### Suggestions and Feedback
[Click here](https://docs.google.com/forms/d/e/1FAIpQLSe5qwunkGf6PUvzPirPDtuy1Du5Rlzew23UBp2S-P3wB-GcwQ/viewform) if you have any feedback or suggestions.
