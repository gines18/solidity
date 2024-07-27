// SPDX-License-Identifier: MIT

pragma solidity ^0.8.20;
import "@openzeppelin/contracts/access/Ownable.sol";

contract Twitter is Ownable {
    uint16 public MAX_TWEET_LENGTH = 180;

    struct Tweet {
        uint id;
        address author;
        string content;
        uint256 timestamp;
        uint256 likes; // Corrected from 'likees' to 'likes'

    }

    mapping(address => Tweet[]) public tweets;

    event TweetCreated(uint256 id, address author, string content, uint256 timestamp);
    event TweetLiked(address liker, address tweetAuthor, uint tweetId, uint256 newLikeCount);
    event TweetUnliked( address unliker, address tweetAuthor, uint256 tweetId, uint256 newLikeCoint);
    constructor() Ownable(msg.sender) {}

    function changeTweetLength(uint16 newTweetLength) public onlyOwner{
        MAX_TWEET_LENGTH = newTweetLength;
    }

    function getTotalLikes( address _author) external view returns(uint){
        uint totalLikes;
              for(uint i = 0; i < tweets[_author].length; i++ ){
              totalLikes += tweets[_author][i].likes;
        }
              return totalLikes;
      
    }

    function createTweet(string memory _tweet) public {

        require(bytes(_tweet).length <= MAX_TWEET_LENGTH , "Tweet is too long bro!");

        Tweet memory newTweet = Tweet({
            id: tweets[msg.sender].length,
            author: msg.sender,
            content: _tweet,
            timestamp: block.timestamp,
            likes: 0
        });

        tweets[msg.sender].push(newTweet);
        emit TweetCreated(newTweet.id, newTweet.author, newTweet.content, newTweet.timestamp);
    }

    function likeTweet(address author, uint256 id ) external {
        require(tweets[author][id].id == id, "Tweet does not exist");
        tweets[author][id].likes++;

        emit TweetLiked(msg.sender, author, id, tweets[author][id].likes);
    }

    function unlikeTweet(address author, uint256 id ) external {
        require(tweets[author][id].id == id, "Tweet does not exist");
        require(tweets[author][id].likes > 0, "Tweet has no likes");
        tweets[author][id].likes--;

         emit TweetUnliked(msg.sender, author, id, tweets[author][id].likes);
    }

    function getTweet(uint _i) public view returns (Tweet memory) {
        return tweets[msg.sender][_i];
    }

    function getAllTweets(address _owner) public view returns (Tweet[] memory) {
        return tweets[_owner];
    }
}