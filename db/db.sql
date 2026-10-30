BEGIN;

CREATE TABLE users (
    id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE
);

CREATE TABLE posts (
    id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    author_id BIGINT NOT NULL,
    title VARCHAR(255) NOT NULL,
    content TEXT NOT NULL,
    comments_enabled BOOLEAN NOT NULL DEFAULT TRUE,
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_posts_author
        FOREIGN KEY (author_id) REFERENCES users(id)
);

CREATE TABLE comments (
    id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    post_id BIGINT NOT NULL,
    author_id BIGINT NOT NULL,
    parent_id BIGINT,
    content VARCHAR(2000) NOT NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_comments_post
        FOREIGN KEY (post_id) REFERENCES posts(id),

    CONSTRAINT fk_comments_author
        FOREIGN KEY (author_id) REFERENCES users(id),

    CONSTRAINT uq_comments_post_id
        UNIQUE (post_id, id),

    CONSTRAINT fk_comments_parent
        FOREIGN KEY (post_id, parent_id)
        REFERENCES comments(post_id, id),

    CONSTRAINT chk_comments_not_self_parent
        CHECK (parent_id IS NULL OR parent_id <> id)
);

CREATE INDEX idx_posts_created_at
    ON posts (created_at, id);

CREATE INDEX idx_comments_post_parent_created_at
    ON comments (post_id, parent_id, created_at, id);

COMMIT;