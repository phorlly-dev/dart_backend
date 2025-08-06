--USER TABLE
CREATE TABLE
    users (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        email TEXT NOT NULL UNIQUE,
        password TEXT NOT NULL,
        --['Male', 'Female', 'Other'];
        sex INTEGER NOT NULL DEFAULT 0 CHECK (sex IN (0, 1, 2)),
        avatar TEXT NULL,
        dob TEXT NULL,
        phone TEXT NULL,
        remember INTEGER NOT NULL DEFAULT 0,
        status INTEGER NOT NULL DEFAULT 1,
        role INTEGER NOT NULL DEFAULT 0,
        created_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
        updated_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP
    );

--TASK TABLE
CREATE TABLE
    tasks (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        note TEXT NULL,
        due_date TEXT NULL,
        attachments TEXT NULL,
        assigned_to INTEGER NOT NULL,
        color INTEGER NOT NULL DEFAULT 0xFF2196F3,
        started_at TEXT NOT NULL,
        ended_at TEXT NOT NULL,
        --"Pending," "In Progress," "Completed," "Failed").
        status INTEGER NOT NULL DEFAULT 0 CHECK (status IN (0, 1, 2, 3)),
        -- (e.g., "High," "Medium," "Low").
        priority INTEGER NOT NULL DEFAULT 0 CHECK (priority IN (0, 1, 2)),
        created_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
        updated_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP
    );

--EVENT TABLE
CREATE TABLE
    events (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        note TEXT NULL,
        -- repetition rule, 0 = none, 1= daily, 2= weekly, 3 = monthly
        repeat_rule INTEGER NOT NULL DEFAULT 0 CHECK (repeat_rule IN (0, 1, 2, 3)),
        -- store as ARGB int (e.g. 0xFF3366CC), not a string
        color INTEGER NOT NULL DEFAULT 0xFF2196F3,
        -- 0 = pending, 1 = loading, 2 = completed, 3 = canceled 
        status INTEGER NOT NULL DEFAULT 0 CHECK (status IN (0, 1, 2, 3)),
        -- minutes before event to remind
        remind_min INTEGER NOT NULL DEFAULT 5,
        -- the “calendar” date of the event, YYYY-MM-DD
        event_date TEXT NOT NULL,
        -- start/end timestamps in full ISO-8601
        start_time TEXT NOT NULL,
        end_time TEXT NOT NULL,
        -- audit fields
        created_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
        updated_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP
    );

-- index for fast date lookups
CREATE INDEX idx_events_event_date ON events (event_date);