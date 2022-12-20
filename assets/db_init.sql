CREATE TABLE t_User(
    id                  TEXT NOT NULL PRIMARY KEY
    ,[name]             TEXT
    ,email              TEXT
    ,createDate         TEXT
    ,linkToAvatar       TEXT
);
CREATE TABLE t_Post(
    id                  TEXT NOT NULL PRIMARY KEY
    ,postContent        TEXT
    ,authorId           TEXT NOT NULL
    ,creationDate         TEXT
    ,FOREIGN KEY(authorId) REFERENCES t_User(id)
);
CREATE TABLE t_PostPhoto(
    id                  TEXT NOT NULL PRIMARY KEY
    ,[name]             TEXT
    ,mimeType           TEXT
    ,[url]              TEXT
    ,postId             TEXT
    ,FOREIGN KEY(postId) REFERENCES t_User(id)
);