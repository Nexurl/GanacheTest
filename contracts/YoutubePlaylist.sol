// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract YouTubePlaylist {
    struct Track {
        uint256 id;
        string title;
        string videoId;
        uint256 voteCount;
    }

    mapping(address => bool) public hasVoted;
    Track[] public tracks;
    uint256 public winningTrackId;

    event TrackAdded(uint256 indexed id, string title, string videoId);
    event Voted(address indexed voter, uint256 indexed trackId);

    function addTrack(string memory _title, string memory _videoId) external {
        tracks.push(Track({
            id: tracks.length,
            title: _title,
            videoId: _videoId,
            voteCount: 0
        }));
        emit TrackAdded(tracks.length - 1, _title, _videoId);
    }

    function vote(uint256 _trackId) external {
        require(!hasVoted[msg.sender], "Already voted");
        require(_trackId < tracks.length, "Invalid track ID");

        tracks[_trackId].voteCount++;
        hasVoted[msg.sender] = true;

        if (tracks[_trackId].voteCount > tracks[winningTrackId].voteCount) {
            winningTrackId = _trackId;
        }

        emit Voted(msg.sender, _trackId);
    }

    function getWinningTrack() external view returns (Track memory) {
        return tracks[winningTrackId];
    }

    function getAllTracks() external view returns (Track[] memory) {
        return tracks;
    }
}