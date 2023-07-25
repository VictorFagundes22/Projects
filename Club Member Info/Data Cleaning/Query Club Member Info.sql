-- Removing the last digit from ages that have more than 105 year old. 277 -> 27.
UPDATE club_member_info
SET AGE = left(age, len(age) -1) WHERE AGE > 105

-- Removing '???' from full_name.
UPDATE club_member_info
SET full_name = case when charindex('???',full_name) = 1 then RIGHT(full_name, LEN(full_name) - 3) else full_name end

-- Removing extra spaces from full_name.
UPDATE club_member_info
SET full_name = trim(full_name)

-- Putting upper case in every column with letters.
UPDATE club_member_info
SET full_name = UPPER(full_name)

UPDATE club_member_info
SET martial_status = UPPER(martial_status)

UPDATE club_member_info
SET email = UPPER(email)

UPDATE club_member_info
SET full_address = UPPER(full_address)

UPDATE club_member_info
SET job_title = UPPER(job_title)

-- Adding new column first_name.
ALTER TABLE club_member_info
ADD first_name NVARCHAR(255)

UPDATE sql_db_1..club_member_info
SET first_name = coalesce(parsename(replace(trim(full_name), ' ', '.'), 4), parsename(replace(trim(full_name), ' ', '.'), 3), parsename(replace(trim(full_name), ' ', '.'), 2))

-- Adding new column last_name.
ALTER TABLE club_member_info
ADD last_name NVARCHAR(255)

UPDATE sql_db_1..club_member_info
SET last_name = substring(trim(full_name),charindex(' ', trim(full_name))+1, LEN(full_name))

-- Removing extra spaces from martial_status.
UPDATE club_member_info
SET martial_status = trim(martial_status)

-- Null values for lines that do not have any register from martial_status.
UPDATE club_member_info
SET martial_status = case when martial_status = '' then null else martial_status end

-- Updating 4 records with wrong spelling.

UPDATE club_member_info
SET martial_status = 'DIVORCED' WHERE martial_status = 'DIVORED'

-- Removing extra spaces from email.
UPDATE club_member_info
SET email = trim(email)

-- Removing extra spaces from phone.
UPDATE club_member_info
SET phone = trim(phone)

-- Setting NULL when the phone does not have 12 characters or if it is empty.
UPDATE club_member_info
SET phone = null where len(phone) <> 12

-- Breaking out full_address into individual columns (street_address, city, state).
ALTER TABLE club_member_info
ADD street_address NVARCHAR(255)

UPDATE club_member_info
SET street_address = TRIM(PARSENAME(REPLACE(full_address, ',','.'), 3))

ALTER TABLE club_member_info
ADD city NVARCHAR(255)

UPDATE club_member_info
SET city = TRIM(PARSENAME(REPLACE(full_address, ',','.'), 2))

ALTER TABLE club_member_info
ADD state NVARCHAR(255)

UPDATE club_member_info
SET state = TRIM(PARSENAME(REPLACE(full_address, ',','.'), 1))

 -- Cleaning misspelling of state names.
 UPDATE	club_member_info
SET state = 'kansas'
WHERE state = 'kansus';

UPDATE club_member_info
SET state = 'district of columbia'
WHERE state = 'districts of columbia';

UPDATE club_member_info
SET state = 'north carolina'
WHERE state = 'northcarolina';

UPDATE club_member_info
SET state = 'california'
WHERE state = 'kalifornia';

UPDATE club_member_info
SET state = 'texas'
WHERE state = 'tejas';

UPDATE club_member_info
SET state = 'texas'
WHERE state = 'tej+f823as';

UPDATE club_member_info
SET state = 'tennessee'
WHERE state = 'tennesseeee';

UPDATE club_member_info
SET state = 'new york'
WHERE state = 'newyork';

-- Seeing how many e-mails are duplicated.
SELECT COUNT(*), email FROM club_member_info GROUP BY email HAVING COUNT(*) > 1

-- Deleting duplicated e-mails.
DELETE FROM club_member_info WHERE member_id in (
	SELECT c2.member_id FROM club_member_info c1
	join club_member_info c2 on c1.email = c2.email
	WHERE c1.member_id < c2.member_id)

-- Updating job_titles that don't have register to null.
UPDATE club_member_info
SET job_title = null where job_title = ''