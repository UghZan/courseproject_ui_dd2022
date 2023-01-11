CREATE TABLE t_User(
    id                  TEXT NOT NULL PRIMARY KEY
    ,[name]             TEXT
    ,email              TEXT
    ,createDate         TEXT
    ,linkToAvatar       TEXT
    ,subscribersCount   INTEGER DEFAULT 0
    ,subscriptionsCount INTEGER DEFAULT 0
);
CREATE TABLE t_Post(
    id                  TEXT NOT NULL PRIMARY KEY
    ,postContent        TEXT
    ,authorId           TEXT NOT NULL
    ,creationDate       TEXT
    ,reactionsCount     INTEGER DEFAULT 0
    ,commentsCount      INTEGER DEFAULT 0
    ,FOREIGN KEY(authorId) REFERENCES t_User(id)
);
CREATE TABLE t_Comment(
    id                  TEXT NOT NULL PRIMARY KEY
    ,postContent        TEXT
    ,authorId           TEXT NOT NULL
    ,creationDate       TEXT
    ,reactionsCount     INTEGER DEFAULT 0
    ,postId             TEXT
    ,FOREIGN KEY(authorId) REFERENCES t_User(id)
    ,FOREIGN KEY(postId) REFERENCES t_Post(id)
);
CREATE TABLE t_PostPhoto(
    id                  TEXT NOT NULL PRIMARY KEY
    ,[name]             TEXT
    ,mimeType           TEXT
    ,[url]              TEXT
    ,postId             TEXT
    ,FOREIGN KEY(postId) REFERENCES t_Post(id)
);