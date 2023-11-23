// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

error NotOwner();
error BookDoesNotExist();


contract Bookstore {

    struct Book {
        string title;
        string author; 
        string publication;
        bool available;
    }

    address private immutable i_owner;
    uint256 private bookId;

    mapping (uint256 => Book) idToBook;
    mapping (string => uint[]) authorToBooks;
    mapping (string => uint[]) publicationToBooks;
    mapping (string => uint[]) titleToBooks;


    constructor(){
        i_owner = msg.sender;
        bookId = 1;
  
    }

    modifier onlyOwner {
        if (msg.sender != i_owner) revert NotOwner();
        _;
    }

    // this function can add a book and only accessible by gavin
    function addBook(string memory title, string memory author, string memory publication) public onlyOwner {
        Book memory newBook = Book({title:title,author:author,publication:publication,available:true});

        idToBook[bookId] = newBook;
        authorToBooks[author].push(bookId);
        publicationToBooks[publication].push(bookId);
        titleToBooks[title].push(bookId);
        bookId++;
     
    }

    // this function makes book unavailable and only accessible by gavin
    function removeBook(uint id) public onlyOwner {
        if (bytes(idToBook[id].title).length == 0) revert BookDoesNotExist();
        idToBook[id].available = false;
    }



    // this function modifies the book details and only accessible by gavin
    function updateDetails(
        uint id, 
        string memory title, 
        string memory author, 
        string memory publication, 
        bool available) public onlyOwner {
             if (bytes(idToBook[id].title).length == 0) revert BookDoesNotExist();
            Book memory updatedBook = Book({title:title,author:author,publication:publication,available:available});
            idToBook[id] = updatedBook;
        
    }

    // this function returns the ID of all books with given title
    function findBookByTitle(string memory title) public view returns (uint[] memory)  {
        
        if (msg.sender != i_owner) {
            uint length;
            unchecked {
                for (uint i; i < titleToBooks[title].length ; i++) 
                {   
                    uint _id = titleToBooks[title][i];
                    if ((idToBook[_id].available)) {
                        
                        length++;

                    } 
                    
                }
            }
            uint[] memory ids = new uint[](length);
            unchecked {
                uint j;
                for (uint i; i < titleToBooks[title].length ; i++) 
                {   
                    uint _id = titleToBooks[title][i];
                    if ((idToBook[_id].available)) {
                        ids[j] = _id;
                        j++;

                    } 
                    
                }
            }

            return ids;
        }
        
        return titleToBooks[title];
    }

    // this function returns the ID of all books with given publication
    function findAllBooksOfPublication (string memory publication) public view returns (uint[] memory)  {
        if (msg.sender != i_owner) {
            uint length;
            unchecked {
                for (uint i; i < publicationToBooks[publication].length ; i++) 
                {   
                    uint _id = publicationToBooks[publication][i];
                    if ((idToBook[_id].available)) {
                        
                        length++;

                    } 
                    
                }
            }
            uint[] memory ids = new uint[](length);
            unchecked {
                uint j;
                for (uint i; i < publicationToBooks[publication].length ; i++) 
                {   
                    uint _id = publicationToBooks[publication][i];
                    if ((idToBook[_id].available)) {
                        ids[j] = _id;
                        j++;
                    } 
                    
                }
            }

            return ids;
        }
        
        return publicationToBooks[publication];
    }
    

    // this function returns the ID of all books with given author
    function findAllBooksOfAuthor (string memory author) public view  returns (uint[] memory)  {
        if (msg.sender != i_owner) {
            uint length;
            unchecked {
                for (uint i; i < authorToBooks[author].length ; i++) 
                {   
                    uint _id = authorToBooks[author][i];
                    if ((idToBook[_id].available)) {
                        
                        length++;

                    } 
                    
                }
            }
            uint[] memory ids = new uint[](length);
            unchecked {
                uint j;
                for (uint i; i < authorToBooks[author].length ; i++) 
                {   
                    uint _id = authorToBooks[author][i];
                    if ((idToBook[_id].available)) {
                        ids[j] = _id;
                        j++;
                    } 
                    
                }
            }

            return ids;
        }

        return authorToBooks[author];
    }

    // this function returns all the details of book with given ID
    function getDetailsById(uint id) public view returns (
        string memory title, 
        string memory author, 
        string memory publication, 
        bool available)  {
            if (bytes(idToBook[id].title).length == 0) revert BookDoesNotExist();
            if (msg.sender != i_owner && !idToBook[id].available) revert NotOwner();
            title = idToBook[id].title;
            author = idToBook[id].author;
            publication = idToBook[id].publication;
            available = idToBook[id].available;
        }

}