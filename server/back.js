const { ethers } = require('ethers');
const { googleapis } = require('googleapis');
const { ganache } = require("ganache");

const provider = new ethers.providers.Web3Provider(ganache.provider());

// Blockchain Setup
// const provider = new ethers.providers.JsonRpcProvider('http://127.0.0.1:7545');
// const contract = artifacts.require("YouTubePlaylist");
const contract = new ethers.Contract(CONTRACT_ADDRESS, CONTRACT_ABI, provider);

// YouTube Setup
const youtube = googleapis.youtube({
    version: 'v3',
    auth: process.env.YOUTUBE_API_KEY
});

// Listen for votes
contract.on('Voted', async (voter, trackId) => {
    const winningTrack = await contract.getWinningTrack();
    await addToPlaylist(winningTrack.videoId);
});

async function addToPlaylist(videoId) {
    await youtube.playlistItems.insert({
        part: 'snippet',
        resource: {
            snippet: {
                playlistId: process.env.PLAYLIST_ID,
                resourceId: {
                    kind: 'youtube#video',
                    videoId: videoId
                }
            }
        }
    });
}