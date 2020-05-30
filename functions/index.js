const functions = require('firebase-functions');
const admin = require('firebase-admin');
const puppeteer = require('puppeteer');
admin.initializeApp();



// // Create and Deploy Your First Cloud Functions
// // https://firebase.google.com/docs/functions/write-firebase-functions
//
// exports.helloWorld = functions.https.onRequest((request, response) => {
//  response.send("Hello from Firebase!");
// });


exports.onCreateUser = functions.firestore
    .document('/anonymousUsers/{userId}')
    .onCreate(async (snapshot, context) => {
        console.log('User Created', snapshot.id);

        var newsTitle;
        var newsContent;
        var imageUrl;
        var url = 'https://www.onlinekhabar.com/2020/05/868748';
        var iconUrl = 'https://lh3.googleusercontent.com/7fQNxv7HXXzN8SivPrNCxvK6Wii_VcKmvyGUvXDlGumOaBOxeFPOAk1zZ2BrWzW3TQ';
        var source = 'OnlineKhabar';

        async function scrapeNews(url) {
            const browser = await puppeteer.launch({
                ignoreDefaultArgs: ['--disable-extensions'],
            });

            const page = await browser.newPage();
            await page.goto(url);

            const [el1] = await page.$x('//*[@id="main"]/section/div/div[1]/h2');
            const title = await el1.getProperty('textContent');
            newsTitle = await title.jsonValue();
            console.log(newsTitle);

            const [el2] = await page.$x('//*[@id="main"]/section/div/div[2]/div/div/div[2]/img');
            const image = await el2.getProperty('src');
            imageUrl = await image.jsonValue();
            console.log(imageUrl);

            const [el3] = await page.$x('//*[@id="main"]/section/div/div[2]/div/div/div[4]');
            const content = await el3.getProperty('textContent');
            newsContent = await content.jsonValue();
            console.log(newsContent);


            await browser.close();

        }

        scrapeNews(url);

        const newsRef = admin.firestore();
        const querySnapshot = await newsRef.get();

        let data = {
            newsTitle: newsTitle,
            imageUrl: imageUrl,
            newsContent: newsContent,
            iconUrl: iconUrl,
            source: source,
        };

        console.log(data);
        newsRef.collection('news').add(data);

    });