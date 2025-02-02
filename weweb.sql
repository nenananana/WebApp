PGDMP      	                 }            webapp    16.6    16.6 &    �           0    0    ENCODING    ENCODING        SET client_encoding = 'UTF8';
                      false            �           0    0 
   STDSTRINGS 
   STDSTRINGS     (   SET standard_conforming_strings = 'on';
                      false            �           0    0 
   SEARCHPATH 
   SEARCHPATH     8   SELECT pg_catalog.set_config('search_path', '', false);
                      false            �           1262    16609    webapp    DATABASE     z   CREATE DATABASE webapp WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE_PROVIDER = libc LOCALE = 'Russian_Russia.1251';
    DROP DATABASE webapp;
                postgres    false            �            1255    16610    insert_test_information()    FUNCTION       CREATE FUNCTION public.insert_test_information() RETURNS void
    LANGUAGE sql
    AS $$-- Очистка базы данных
DELETE FROM public.accident;
DELETE FROM public.mileage;
DELETE FROM public.owner;
DELETE FROM public.car;
DELETE FROM public.brands;



-- Добавление данных в таблицу brands
INSERT INTO public.brands("title", "full_title", "country") VALUES
('BMW', 'Bayerische Motoren Werke AG', 'Германия'),
('Skoda', 'Skoda Holding', 'Чехия'),
('Volkswagen', 'Volkswagen AG', 'Германия'),
('Volvo', 'Volvo Group', 'Швеция');


-- Добавление данных в таблицу car
INSERT INTO public.car("number", "brand", "model", "color") VALUES
('A123AA777', 'BMW', 'M5', 'Красный'),
('B789AB123', 'Volvo', 'XC40', 'Зеленый'),
('C456BC789', 'Volkswagen', 'Tiguan', 'Коричневый'),
('D123CD123', 'Skoda', 'Kodiaq', 'Фиолетовый'),
('E890DE456', 'Skoda', 'Kodiaq', 'Серый'),
('O000OO001', 'BMW', 'M9', 'Розовый');


-- Добавление данных в таблицу owner
INSERT INTO public.owner("number", "name", "secondName", "surname") VALUES
('A123AA777', 'Иван', 'Иванов', 'Иванович'),
('B789AB123', 'Анна', 'Петрова ', 'Сергеевна'),
('C456BC789', 'Михаил', 'Сидоров', 'Владимирович'),
('D123CD123', 'Алексей', 'Кузнецов', 'Владимирович'),
('E890DE456', 'Павел', 'Григорьев', 'Алексеевич'),
('O000OO001', 'Станислав', 'Громов', 'Викторович'),
('O000OO001', 'Петр', 'Громов', 'Андреевич'),
('O000OO001', 'Алексей', 'Чехов', 'Павлович');


-- Добавление данных в таблицу accident
INSERT INTO public.accident("number", "date", "type", "region") VALUES
('A123AA777', '2023-03-15', 'Столкновение', 'Московская область'),
('B789AB123', '2019-03-18', 'Опрокидывание', 'Республика Коми'),
('C456BC789', '2023-03-20', 'Наезд', 'Новгородская область'),
('D123CD123', '2022-03-22', 'Наезд', 'Пермская область'),
('E890DE456', '2023-03-25', 'Столкновение', 'Пермская область'),
('O000OO001', '2020-03-20', 'Наезд', 'Тюменская область'),
('O000OO001', '2021-07-21', 'Столкновение', 'Ханты-Мансийский автономный округ - Югра'),
('O000OO001', '2023-09-24', 'Опрокидывание', 'Ямало-Ненецкий автономный округ');


-- Добавление данных в таблицу mileage
INSERT INTO public.mileage("number", "fixationDate", "fixationValue") VALUES
('A123AA777', '2023-05-15', 100000),
('B789AB123', '2023-12-18', 53492),
('C456BC789', '2024-08-20', 129456),
('D123CD123', '2024-05-22', 321099),
('E890DE456', '2024-10-25', 1024),
('O000OO001', '2024-03-20', 266902),
('O000OO001', '2024-07-21', 565000),
('O000OO001', '2023-09-24', 702353);$$;
 0   DROP FUNCTION public.insert_test_information();
       public          postgres    false            �           0    0 "   FUNCTION insert_test_information()    COMMENT     �   COMMENT ON FUNCTION public.insert_test_information() IS 'Удаляет  из всех таблиц  все записи и вставляет тестовые записи.';
          public          postgres    false    222            �            1255    16611 &   select_car_accident(character varying)    FUNCTION     }  CREATE FUNCTION public.select_car_accident(car_number character varying) RETURNS TABLE("Номер" character varying, "Модель" text, "Цвет" text, "Дата" date, "Вид происшествия" text, "Регион" text)
    LANGUAGE plpgsql
    AS $$
BEGIN
  RETURN QUERY
  SELECT 
    car.number AS "Номер", 
    car.model AS "Модель", 
    car.color AS "Цвет",
    accident.date AS "Дата", 
    accident.type AS "Вид происшествия", 
    accident.region AS "Регион"
  FROM public.car
  JOIN public.accident ON car.number = accident.number
  WHERE car.number = car_number;
END;
$$;
 H   DROP FUNCTION public.select_car_accident(car_number character varying);
       public          postgres    false            �            1255    16612    select_car_by_brand(text)    FUNCTION     a  CREATE FUNCTION public.select_car_by_brand(brand_name text) RETURNS TABLE("Номер" character varying, "Модель" text, "Цвет" text)
    LANGUAGE plpgsql
    AS $$
BEGIN
  RETURN QUERY
  SELECT 
    "number" AS "Номер", 
    "model" AS "Модель", 
    "color" AS "Цвет" 
  FROM public.car
  WHERE "brand" = brand_name;
END;
$$;
 ;   DROP FUNCTION public.select_car_by_brand(brand_name text);
       public          postgres    false            �            1255    16812 &   transliterate_russian_to_english(text)    FUNCTION     �  CREATE FUNCTION public.transliterate_russian_to_english(input_text text) RETURNS text
    LANGUAGE plpgsql
    AS $$
DECLARE
    output_text TEXT := '';
    i INT := 1;
    current_char CHAR;
BEGIN
    WHILE i <= LENGTH(input_text) LOOP
        current_char := SUBSTRING(input_text FROM i FOR 1);
        output_text := output_text || CASE
            WHEN current_char = 'П' THEN 'P'  -- Явное преобразование для "П"
            WHEN current_char = 'п' THEN 'p'  -- Явное преобразование для "п"
            -- Остальные символы (как в предыдущей функции)
            WHEN current_char = 'А' THEN 'A'
            WHEN current_char = 'Б' THEN 'B'
            WHEN current_char = 'В' THEN 'V'
            WHEN current_char = 'Г' THEN 'G'
            WHEN current_char = 'Д' THEN 'D'
            WHEN current_char = 'Е' THEN 'E'
            WHEN current_char = 'Ё' THEN 'Yo'
            WHEN current_char = 'Ж' THEN 'Zh'
            WHEN current_char = 'З' THEN 'Z'
            WHEN current_char = 'И' THEN 'I'
            WHEN current_char = 'Й' THEN 'Y'
            WHEN current_char = 'К' THEN 'K'
            WHEN current_char = 'Л' THEN 'L'
            WHEN current_char = 'М' THEN 'M'
            WHEN current_char = 'Н' THEN 'N'
            WHEN current_char = 'О' THEN 'O'
            WHEN current_char = 'Р' THEN 'R'
            WHEN current_char = 'С' THEN 'S'
            WHEN current_char = 'Т' THEN 'T'
            WHEN current_char = 'У' THEN 'U'
            WHEN current_char = 'Ф' THEN 'F'
            WHEN current_char = 'Х' THEN 'Kh'
            WHEN current_char = 'Ц' THEN 'Ts'
            WHEN current_char = 'Ч' THEN 'Ch'
            WHEN current_char = 'Ш' THEN 'Sh'
            WHEN current_char = 'Щ' THEN 'Shch'
            WHEN current_char = 'Ъ' THEN ''
            WHEN current_char = 'Ы' THEN 'Y'
            WHEN current_char = 'Ь' THEN ''
            WHEN current_char = 'Э' THEN 'E'
            WHEN current_char = 'Ю' THEN 'Yu'
            WHEN current_char = 'Я' THEN 'Ya'
            WHEN current_char = 'а' THEN 'a'
            WHEN current_char = 'б' THEN 'b'
            WHEN current_char = 'в' THEN 'v'
            WHEN current_char = 'г' THEN 'g'
            WHEN current_char = 'д' THEN 'd'
            WHEN current_char = 'е' THEN 'e'
            WHEN current_char = 'ё' THEN 'yo'
            WHEN current_char = 'ж' THEN 'zh'
            WHEN current_char = 'з' THEN 'z'
            WHEN current_char = 'и' THEN 'i'
            WHEN current_char = 'й' THEN 'y'
            WHEN current_char = 'к' THEN 'k'
            WHEN current_char = 'л' THEN 'l'
            WHEN current_char = 'м' THEN 'm'
            WHEN current_char = 'н' THEN 'n'
            WHEN current_char = 'о' THEN 'o'
            WHEN current_char = 'р' THEN 'r'
            WHEN current_char = 'с' THEN 's'
            WHEN current_char = 'т' THEN 't'
            WHEN current_char = 'у' THEN 'u'
            WHEN current_char = 'ф' THEN 'f'
            WHEN current_char = 'х' THEN 'kh'
            WHEN current_char = 'ц' THEN 'ts'
            WHEN current_char = 'ч' THEN 'ch'
            WHEN current_char = 'ш' THEN 'sh'
            WHEN current_char = 'щ' THEN 'shch'
            WHEN current_char = 'ъ' THEN ''
            WHEN current_char = 'ы' THEN 'y'
            WHEN current_char = 'ь' THEN ''
            WHEN current_char = 'э' THEN 'e'
            WHEN current_char = 'ю' THEN 'yu'
            WHEN current_char = 'я' THEN 'ya'
            ELSE ''  -- Игнорируем все остальные символы
        END;
        i := i + 1;
    END LOOP;
    RETURN output_text;
END;
$$;
 H   DROP FUNCTION public.transliterate_russian_to_english(input_text text);
       public          postgres    false            �            1259    16807    __EFMigrationsHistory    TABLE     �   CREATE TABLE public."__EFMigrationsHistory" (
    "MigrationId" character varying(150) NOT NULL,
    "ProductVersion" character varying(32) NOT NULL
);
 +   DROP TABLE public."__EFMigrationsHistory";
       public         heap    postgres    false            �            1259    16613    accident    TABLE       CREATE TABLE public.accident (
    number character varying(9) NOT NULL,
    date date NOT NULL,
    id integer NOT NULL,
    login character varying(255),
    departureaddress character varying(255),
    destinationaddress character varying(255),
    sum numeric(18,2)
);
    DROP TABLE public.accident;
       public         heap    postgres    false            �            1259    16618    accident_id_seq    SEQUENCE     �   CREATE SEQUENCE public.accident_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 &   DROP SEQUENCE public.accident_id_seq;
       public          postgres    false    215            �           0    0    accident_id_seq    SEQUENCE OWNED BY     C   ALTER SEQUENCE public.accident_id_seq OWNED BY public.accident.id;
          public          postgres    false    216            �            1259    16619    brands    TABLE     q   CREATE TABLE public.brands (
    title text NOT NULL,
    full_title text NOT NULL,
    country text NOT NULL
);
    DROP TABLE public.brands;
       public         heap    postgres    false            �            1259    16624    car    TABLE     �   CREATE TABLE public.car (
    number character varying(9) NOT NULL,
    brand text NOT NULL,
    model text NOT NULL,
    color text NOT NULL
);
    DROP TABLE public.car;
       public         heap    postgres    false            �            1259    16633    owner    TABLE     &  CREATE TABLE public.owner (
    number character varying(9) NOT NULL,
    name text NOT NULL,
    "secondName" text,
    surname text,
    id integer NOT NULL,
    "Login" text,
    CONSTRAINT check_car_number CHECK (((number)::text ~* '[А-ЯA-Z]{1}[0-9]{3}[А-ЯA-Z]{2}[0-9]{2,3}'::text))
);
    DROP TABLE public.owner;
       public         heap    postgres    false            �            1259    16639    owner_id_seq    SEQUENCE     �   CREATE SEQUENCE public.owner_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 #   DROP SEQUENCE public.owner_id_seq;
       public          postgres    false    219            �           0    0    owner_id_seq    SEQUENCE OWNED BY     =   ALTER SEQUENCE public.owner_id_seq OWNED BY public.owner.id;
          public          postgres    false    220            /           2604    16640    accident id    DEFAULT     j   ALTER TABLE ONLY public.accident ALTER COLUMN id SET DEFAULT nextval('public.accident_id_seq'::regclass);
 :   ALTER TABLE public.accident ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    216    215            0           2604    16642    owner id    DEFAULT     d   ALTER TABLE ONLY public.owner ALTER COLUMN id SET DEFAULT nextval('public.owner_id_seq'::regclass);
 7   ALTER TABLE public.owner ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    220    219            �          0    16807    __EFMigrationsHistory 
   TABLE DATA           R   COPY public."__EFMigrationsHistory" ("MigrationId", "ProductVersion") FROM stdin;
    public          postgres    false    221   uH       �          0    16613    accident 
   TABLE DATA           f   COPY public.accident (number, date, id, login, departureaddress, destinationaddress, sum) FROM stdin;
    public          postgres    false    215   �H       �          0    16619    brands 
   TABLE DATA           <   COPY public.brands (title, full_title, country) FROM stdin;
    public          postgres    false    217   �L       �          0    16624    car 
   TABLE DATA           :   COPY public.car (number, brand, model, color) FROM stdin;
    public          postgres    false    218   �M       �          0    16633    owner 
   TABLE DATA           Q   COPY public.owner (number, name, "secondName", surname, id, "Login") FROM stdin;
    public          postgres    false    219   �O       �           0    0    accident_id_seq    SEQUENCE SET     >   SELECT pg_catalog.setval('public.accident_id_seq', 46, true);
          public          postgres    false    216            �           0    0    owner_id_seq    SEQUENCE SET     <   SELECT pg_catalog.setval('public.owner_id_seq', 116, true);
          public          postgres    false    220            ?           2606    16811 .   __EFMigrationsHistory PK___EFMigrationsHistory 
   CONSTRAINT     {   ALTER TABLE ONLY public."__EFMigrationsHistory"
    ADD CONSTRAINT "PK___EFMigrationsHistory" PRIMARY KEY ("MigrationId");
 \   ALTER TABLE ONLY public."__EFMigrationsHistory" DROP CONSTRAINT "PK___EFMigrationsHistory";
       public            postgres    false    221            5           2606    16644    accident accident_pkey 
   CONSTRAINT     T   ALTER TABLE ONLY public.accident
    ADD CONSTRAINT accident_pkey PRIMARY KEY (id);
 @   ALTER TABLE ONLY public.accident DROP CONSTRAINT accident_pkey;
       public            postgres    false    215            7           2606    16646    brands brands_pkey 
   CONSTRAINT     S   ALTER TABLE ONLY public.brands
    ADD CONSTRAINT brands_pkey PRIMARY KEY (title);
 <   ALTER TABLE ONLY public.brands DROP CONSTRAINT brands_pkey;
       public            postgres    false    217            9           2606    16648    brands brands_title_key 
   CONSTRAINT     S   ALTER TABLE ONLY public.brands
    ADD CONSTRAINT brands_title_key UNIQUE (title);
 A   ALTER TABLE ONLY public.brands DROP CONSTRAINT brands_title_key;
       public            postgres    false    217            ;           2606    16650    car car_pkey 
   CONSTRAINT     N   ALTER TABLE ONLY public.car
    ADD CONSTRAINT car_pkey PRIMARY KEY (number);
 6   ALTER TABLE ONLY public.car DROP CONSTRAINT car_pkey;
       public            postgres    false    218            2           2606    16651    car check_car_number    CHECK CONSTRAINT     �   ALTER TABLE public.car
    ADD CONSTRAINT check_car_number CHECK (((number)::text ~* '[А-ЯA-Z]{1}[0-9]{3}[А-ЯA-Z]{2}[0-9]{2,3}'::text)) NOT VALID;
 9   ALTER TABLE public.car DROP CONSTRAINT check_car_number;
       public          postgres    false    218    218            1           2606    16652    accident check_car_number    CHECK CONSTRAINT     �   ALTER TABLE public.accident
    ADD CONSTRAINT check_car_number CHECK (((number)::text ~* '[А-ЯA-Z]{1}[0-9]{3}[А-ЯA-Z]{2}[0-9]{2,3}'::text)) NOT VALID;
 >   ALTER TABLE public.accident DROP CONSTRAINT check_car_number;
       public          postgres    false    215    215            =           2606    16656    owner owner_pkey 
   CONSTRAINT     N   ALTER TABLE ONLY public.owner
    ADD CONSTRAINT owner_pkey PRIMARY KEY (id);
 :   ALTER TABLE ONLY public.owner DROP CONSTRAINT owner_pkey;
       public            postgres    false    219            @           2606    16657    accident accident_fk0    FK CONSTRAINT     u   ALTER TABLE ONLY public.accident
    ADD CONSTRAINT accident_fk0 FOREIGN KEY (number) REFERENCES public.car(number);
 ?   ALTER TABLE ONLY public.accident DROP CONSTRAINT accident_fk0;
       public          postgres    false    215    218    4667            A           2606    16724    car car_fk1    FK CONSTRAINT     ~   ALTER TABLE ONLY public.car
    ADD CONSTRAINT car_fk1 FOREIGN KEY (brand) REFERENCES public.brands(title) ON DELETE CASCADE;
 5   ALTER TABLE ONLY public.car DROP CONSTRAINT car_fk1;
       public          postgres    false    218    4663    217            B           2606    16734    owner owner_fk0    FK CONSTRAINT     �   ALTER TABLE ONLY public.owner
    ADD CONSTRAINT owner_fk0 FOREIGN KEY (number) REFERENCES public.car(number) ON DELETE CASCADE;
 9   ALTER TABLE ONLY public.owner DROP CONSTRAINT owner_fk0;
       public          postgres    false    218    4667    219            �   t   x��̻
�@���}�e�p��e�6���-� B^_#6�e���	��l��Ю���qy�������PBɡ,�����|{!�B�£��!����4� EsE�v��9��K�      �   �  x����n�V����8�����RJ�e]l�tCCDJX9��f� 	�U6q�.��hS;�p�F�)Z%Y��,���9����T���
>H0!�q���+'��I�����N��F���{���������7���o�v9cO�y��=���)Ş3��X6�8�*̂$���}��wD�CC����Fo��+��K�"λ�[�=��X��7�7q�џq�qZH�����+�l�N�1�����D*�h^��|?z��� ���e�ڌ�$����8�� AN#D����k!���j�H&�=)��qПF5I(jv���r[�S(.|B����s��H��F�hx=�|�u���H.]�(WT���I����Wa�rR�������-KCU��iM�"ia��¿~u����-���JpW@ک��=Kڳ������,�jRU��5��,� �k��e�ϧk�W�֤���\۷S]�%IN�Z���<�N�|Ce����@y�����$�u�~�r�w�Lm���FY�$�>P�=iKI�R����s��*/�/�E��X��X���S��:��&��Nf�^Y ���t�~����c��ȩ]$���	�F��q��ஃ�Q#mZ`"�6�������o��EyKG@�h�=��$M:+�k[�gz��lE��i t��v6$*-�x���Z��E�X;@�ĸ���j�-ˈ���K��GD��L�����}a�6J���dO�%`b;ώGH�M��OҶ�>78�Z�\������]�����+�!��j�����e�S�t� �륍3$:ɿXG:k��Ȳ�I��읦���a��/�Wa?��bfT%�.��VlNh��2���zqFnrS5i*�>�����/|8� w_y�؏�z�TN�2��F�z���=e�4�ǖ��������=U�      �   �   x�m�1n�@E��S�	|@�8��f�W`�ٱ��]���.R$R%	�"!W��Qp���?Ҽ�#C�Qu��(vc��j��j���&�{3���F����<�|��3����"#�b+��i���iJ���hbu�s��4�>�W�n�����μn��؛<fGx�75�f�Q.�]f\Ix�'�ԍu�Hs�]�A# �H���v��E&����a/]�j���A.wr3�R?����      �     x�e��n�@��g��O��8�eY_ss��nZ$6C<+���ʮbÂ@b{$Dj�a�F���Ж�ǒ}�7��g��`xn�V<�q�2�
�O�������M̮�3L,�5��nXQ��h⳸?܈��q�?��L�@��1�)���7q+�%���u�=*��;<���U7�
_Q��!�/���Du�o۪��W; ���f�HӴ(R�s���8�a���_�t�P0R����uMK��ʻ<}����S����Nl��i;269וnN��F��4D|�K
&�y�RXL丣!�:<�qYW�I�c9q�4+8}�2Z�%��O�����㉌|����&U�g�)�&c�N���8��q���E:.hQв��"y�Ɍj˰�H���e<RR;Y���V��8�e4�*}�sD���Qԫ��f�V�G�b)3jU-,`y�@�2�)��!�Jz��v�� TNgVoY���F͕r�k��х��]�G!�b%����#��!�M}      �   +  x�mW]oW}����o?����bc	ԗE^��oe'��SBJA*%�*�@�j_J�'��_���:3���]'BD����sΜ�p1���F"	ⵘ��X��(���;K�S����_��S�da����8VJ�3�� q*&xh� ��~�1�x3�˙��)F�@&u�}�w�V��//�Ax��^��$�_0�L\zG*��Ck��1Tr�x��@���㋷x��?����s"� E6�M��ݵF3�7�=�@�I�������Jրr�;=�J����a`��5�9+�/�;o��pP��C���N&���a$�g�	T`N��9��)�s�MB���	Q�-�X��b�=G}9'+� |�$:śO�*s�)͖�y: ���d�TN��_L&��9�aF�~e�Ku*�*��5r�0VJ���J&��	�?��{/�`��'�{��,����}�`oD��ȭRe�FaM��B��;���P�,��q�<���54ɍH��а'��La9�t�������Ѳw�����j���$�,	��{��K���<u�C�����,5�rk#N���蹤(A8÷��
U��;b�K�9W8	T.�:��}8�����۸ͅ���Bb��_�/���U��,����Һm�|qgb��d1����9���\�:h�������DP�\��3�����kח|�W>LI/	����x��DZ�u6�G)s �N�9��Y%���No�r��ȱ�`���Kb�e����+�G���p�h�,�WGj�&{;x���DJ�N��d�Ӷ��q4�Ss��}C�&�#��[ �ʂ��0P�l�a�9�1��J
5��kU��A�tw-�9��|�l���KZ��B�Z=t�C�9$w��v���^k��y�(���qW���Fi��E�-'F�Y�ɜx/��h*e�0����zL��\�w��zB/��;�u>��@m@+2��v��9{� �F^w;liMHnfd?5�Ϲ�-�P�o��TQ�ɪ�0U�:��_�$�W��l� L
6��G��E̚�2
J�.���J�w�_>��~wx`����zMR�{��ox$���nDG������Y� �j9�B�tFv�h�Z���z?�&<�2��3���9<�GǴ&$���5��@w�Pn;{xU��J9��,।��;V�F1�q���[�0;�L�$#�TSqY�>2�f��im�'�[�M���di4�r6+�ю��Tז-*Tٺ��uLB��voD�M�P55�l�e�?���;fd�Z�4L�o��Ei�XӒ�Srq��H�kn�Ӱ]��Cn��<䔙~�u�ou�x]���8\r�6�Y�n��=�#��va��Q���
�o�}K�?,x{��Zڱ�kX�?j�S"�b��#�ϣ�v4���	�e{�{�PnU���@�6z9�o�7���B����6���+^q[W���uGM@���G;ō�_��Ҽ8�M@I}Ӥ1�$tZ�؋����"׉�0�7M�HA��b��7�el��\�'�N 㤡�ڱG{LJ��AZ@���yiN�f'�M/�4����b�����`     