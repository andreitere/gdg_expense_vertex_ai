"""init

Revision ID: b2f88f9bcf9e
Revises: 
Create Date: 2024-08-28 17:40:02.338128

"""
from alembic import op
import sqlalchemy as sa

# revision identifiers, used by Alembic.
revision = 'b2f88f9bcf9e'
down_revision = None
branch_labels = None
depends_on = None


def upgrade() -> None:
    op.execute("""
           create table if not exists public.users (
               user_id int primary key generated always as identity,
               email VARCHAR(255) not null unique,
               first_name VARCHAR(100),
               last_name VARCHAR(100),
               bio TEXT,
               password_hash VARCHAR(255),
               profile_picture_url VARCHAR(255),
               confirmed boolean default false,
               created_at TIMESTAMP WITH TIME ZONE default current_timestamp,
               confirmed_at TIMESTAMP WITH TIME ZONE,
               updated_at TIMESTAMP WITH TIME ZONE default current_timestamp
           );
       """)
    op.execute("""create or replace function public.generate_gravatar_url(p_email TEXT, p_size INT default 400, p_default TEXT default 'retro')
            returns TEXT as $$
            declare
                email_hash TEXT;
                gravatar_url TEXT;
            begin
                -- Convert the email to lowercase and calculate the MD5 hash
                email_hash := md5(lower(trim(p_email)));

                -- Construct the Gravatar URL with a default image option
                gravatar_url := 'https://www.gravatar.com/avatar/' || email_hash || '?s=' || p_size || '&d=' || p_default;

                -- Return the Gravatar URL
                return gravatar_url;
            end;
            $$ language plpgsql;
        """)

    op.execute("""CREATE OR REPLACE FUNCTION public.connect_user(p_email text, p_password text)
            RETURNS json AS $$
            DECLARE
                v_pic varchar;
                stored_password text;
                user_exists boolean;
                v_user_id int;
            BEGIN
                -- Check if the user exists by email
                SELECT INTO user_exists, stored_password, v_user_id
                        TRUE, password_hash, user_id
                FROM public.users
                WHERE email = lower(p_email);
            
                IF user_exists THEN
                    -- Check if the stored password matches the hashed input password
                    IF stored_password = crypt(p_password, stored_password) THEN
                        -- Password matches, return success
                        RETURN json_build_object('success', true, 'exists', true, 'user_id', v_user_id);
                    ELSE
                        -- Password does not match, return failure
                        RETURN json_build_object('success', false, 'exists', true);
                    END IF;
                ELSE
                    -- Insert the new user with hashed password
                    
                    select public.generate_gravatar_url(p_email) into v_pic;
                    INSERT INTO public.users(email, password_hash, profile_picture_url)
                    VALUES (lower(p_email), crypt(p_password, gen_salt('bf')), v_pic)
                    returning user_id into v_user_id;
            
                    -- Return success and indicate user was created
                    RETURN json_build_object('success', true, 'exists', true, 'created', true, 'user_id', v_user_id);
                END IF;
            END;
            $$ LANGUAGE plpgsql;
        """)

    op.execute("""
           create table if not exists public.groups (
               group_id int primary key generated always as identity,
               owner_id int not null ,
               title VARCHAR(255) not null,
               category VARCHAR(100),
               description text,
               photo_desc text,
               photo text,
               created_at TIMESTAMP WITH TIME ZONE default current_timestamp
           );
       """)

    op.execute("""CREATE OR REPLACE FUNCTION public.get_user(p_user_id int)
                    RETURNS json AS $$
                    DECLARE
                        v_user json;
                    BEGIN
                        select json_build_object('email', email, 'profile_picture_url', profile_picture_url, 'user_id', user_id) into v_user
                        from public.users
                        where user_id = p_user_id;
                        return v_user;
                    END;
                    $$ LANGUAGE plpgsql;
                """)

    op.execute("""CREATE OR REPLACE FUNCTION public.create_or_update_group(p_group json)
                RETURNS int AS $$
                DECLARE
                    v_group_id int;
                BEGIN
                    -- Attempt to update the group if it already exists
                    UPDATE public.groups
                    SET 
                        title = COALESCE(p_group ->> 'title', title),
                        category = COALESCE(p_group ->> 'category', category),
                        description = COALESCE(p_group ->> 'description', description),
                        photo_desc = COALESCE(p_group ->> 'photo_desc', photo_desc),
                        photo = COALESCE(p_group ->> 'photo', photo)
                    WHERE group_id = (p_group ->> 'group_id')::int
                    RETURNING group_id INTO v_group_id;
                    
                    -- If no rows were updated, insert a new group
                    IF NOT FOUND THEN
                        INSERT INTO public.groups (owner_id, title, category, photo_desc, photo, description)
                        VALUES (
                            (p_group ->> 'owner_id')::int,
                            p_group ->> 'title',
                            p_group ->> 'category',
                            p_group ->> 'photo_desc',
                            p_group ->> 'photo',
                            p_group ->> 'description'
                        )
                        RETURNING group_id INTO v_group_id;
                    END IF;
                
                    -- Return the group ID, whether it was updated or inserted
                    RETURN v_group_id;
                END;
                $$ LANGUAGE plpgsql;
            """)

    op.execute("""
          create table if not exists public.expenses (
              expense_id int primary key generated always as identity,
              group_id int not null,
              owner_id int not null ,
              total float not null,
              title VARCHAR(255) not null unique,
              items jsonb,
              photo text,
              created_at TIMESTAMP WITH TIME ZONE default current_timestamp
          );
      """)

    op.execute("""CREATE OR REPLACE FUNCTION public.add_expense(p_group_id int, p_user_id int, p_total float, p_title varchar, p_items jsonb, p_photo text)
            RETURNS json AS $$
            BEGIN
                insert into public.expenses (group_id, owner_id, total, title, items, photo)
                values (p_group_id, p_user_id, p_total, p_title, p_items, p_photo);
            END;
            $$ LANGUAGE plpgsql;
        """)


def downgrade() -> None:
    op.execute("drop function if exists public.add_expense")
    op.execute("drop function if exists public.get_user")
    op.execute("drop function if exists public.create_or_update_group")
    op.execute("drop function if exists public.connect_user")
    op.execute('drop table if exists public.expenses cascade;')
    op.execute('drop table if exists public.users cascade;')
    op.execute('drop table if exists public.groups cascade;')
