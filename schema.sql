-- schema.sql: the course catalog database schema
-- The file can be run repeatedly: it first drops the old tables.
-- A teaching shortcut: real projects manage the schema with migrations.
DROP TABLE IF EXISTS enrollments, students, courses;

CREATE TABLE courses (
    id          text    PRIMARY KEY,
    title       text    NOT NULL,
    description text    NOT NULL,
    -- TODO 1: credits — required; strictly greater than zero
    credits     integer NOT NULL CHECK (credits > 0),
    -- TODO 2: is_elective — required; defaults to false
    is_elective boolean NOT NULL DEFAULT false,
    -- TODO 3: likes — required; defaults to 0; not less than zero
    likes       integer NOT NULL DEFAULT 0 CHECK (likes >= 0)
);

CREATE TABLE students (
    -- TODO 4: id — an automatic number (bigint) and the primary key
    id    bigint GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    -- TODO 5: name — required; at least two characters long
    name  text   NOT NULL CHECK (length(name) >= 2),
    -- TODO 6: email — required; unique
    email text   NOT NULL UNIQUE
);

CREATE TABLE enrollments (
    id          bigint GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    -- TODO 7: course_id — required; references courses;
    --         a course that has enrollments can't be deleted
    course_id   text   NOT NULL REFERENCES courses (id) ON DELETE RESTRICT,
    -- TODO 8: student_id — required; references students;
    --         when a student is deleted, their enrollments are deleted
    student_id  bigint NOT NULL REFERENCES students (id) ON DELETE CASCADE,
    -- TODO 9: enrolled_at — required; defaults to the current moment
    enrolled_at timestamptz NOT NULL DEFAULT now(),
    -- TODO 10: the pair (course_id, student_id) is unique
    UNIQUE (course_id, student_id)
);

-- Index on the foreign key student_id (step 6): PostgreSQL doesn't create one.
CREATE INDEX enrollments_student_id_idx ON enrollments (student_id);
