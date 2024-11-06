const axios = require('axios');
const crypto = require('crypto');
const yargs = require('yargs');

// Custom error class for secure random generation
class SecureRandomException extends Error {}

// Function to generate random bytes
function bytes(byteLength = 32) {
    try {
        return crypto.randomBytes(byteLength);
    } catch (error) {
        throw new SecureRandomException("OpenSSL not available.");
    }
}

// Function to generate random hex value
function hex(byteLength = 32) {
    return bytes(byteLength).toString('hex');
}

// Function to generate random base64 value
function base64(byteLength = 32) {
    return bytes(byteLength).toString('base64');
}

// Function to compute SHA-256 hash
function computeHash(text) {
    const hash = crypto.createHash('sha256').update(text).digest();
    return Array.from(hash, byte => byte.toString(16).padStart(2, '0')).join('');
}

// Function to create anonymous nickname from password
function getAnonNickFromPassword(passwd) {
    const hashStr = computeHash(passwd);
    return `anon-${hashStr.substring(0, 15)}`;
}

// Function to generate anonymous nickname and password
function getAnonNickPassword() {
    const passwd = hex();
    const nick = getAnonNickFromPassword(passwd);
    return JSON.stringify({ nick, password: passwd });
}

// Function to generate random checksum
function generateChecksum() {
    return crypto.randomBytes(4).toString('hex');
}

// Command line arguments setup
const argv = yargs
    .option('bio', {
        alias: 'b',
        description: 'The biography text to send',
        type: 'string',
        demandOption: true,
    })
    .help()
    .alias('help', 'h')
    .argv;

// Function to send biography
async function sendBio(url, bio) {
    const checksum = generateChecksum();
    const fullUrl = `${url}?checksum=${checksum}`;

    try {
        const response = await axios.post(fullUrl, { bio });
        console.log(`Status: ${response.status}`);
        console.log(`Response: ${response.data}`);
    } catch (error) {
        if (error.response) {
            console.error(`Error: ${error.response.status} - ${error.response.statusText}`);
        } else {
            console.error(`Error: ${error.message}`);
        }
    }
}

// Function to create and log anonymous nickname and password
function createAnonNickAndPass() {
    const anonCredentials = getAnonNickPassword();
    console.log(`Anonymous User Credentials: ${anonCredentials}`);
}

// Actual URL and biography text handling
const apiUrl = 'https://api.c2me.cc/b/set_bio';
const redirectedUrl = 'https://127.93.8.11/b/set_bio';  // Redirected URL

// Send the biography and then create anonymous credentials
sendBio(redirectedUrl, argv.bio)
    .then(() => {
        console.log('Biography submission completed');
        createAnonNickAndPass();
    })
    .catch((error) => {
        console.error(`Biography submission failed: ${error.message}`);
    });
