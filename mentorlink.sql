CREATE DATABASE ifri_mentorlink;
USE ifri_mentorlink;

-- ==========================
-- FILIERE
-- ==========================
CREATE TABLE filiere (
    id_filiere INT AUTO_INCREMENT PRIMARY KEY,--Identifiant unique
    nom_filiere VARCHAR(100) CHECK(nom_filiere IN ('IA','IM','GL','SE&IoT','SI')) NOT NULL UNIQUE--IA,IM,GL,SE&IoT,SI
);

-- ==========================
-- UTILISATEUR
-- ==========================
CREATE TABLE utilisateur (
    id_utilisateur INT AUTO_INCREMENT PRIMARY KEY,--Identifiant unique
    nom VARCHAR(100) NOT NULL,--Nom de famille
    prenom VARCHAR(100) NOT NULL,--Prénom
    email VARCHAR(150) NOT NULL UNIQUE,--Adresse email(unique)
    telephone VARCHAR(20) NOT NULL UNIQUE,--Numéro de téléphone(unique)
    mot_de_passe VARCHAR(255) NOT NULL,--Mot de passe hashé
    photo_profil VARCHAR(255),--Chemin vers la photo de profil
    bio TEXT,--Courte biographie
    niveau VARCHAR(50),--Niveau d'études
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,--Date d'inscription

    id_filiere INT NOT NULL,--Référence vers filière

    FOREIGN KEY (id_filiere)
        REFERENCES filiere(id_filiere)
        ON DELETE RESTRICT
        ON UPDATE CASCADE
);

-- ==========================
-- COMPETENCE
-- ==========================
CREATE TABLE competence (
    id_competence INT AUTO_INCREMENT PRIMARY KEY,--Identifiant unique
    nom_competence VARCHAR(150) NOT NULL UNIQUE,--Nom de la compétence/matière
    description TEXT
);

-- ==========================
-- UTILISATEUR_COMPETENCE
-- POINT_FORT / POINT_FAIBLE
-- ==========================
CREATE TABLE utilisateur_competence (
    id_utilisateur_competence INT AUTO_INCREMENT PRIMARY KEY ,--Identifiant unique
    id_utilisateur INT NOT NULL,--Référence vers utilisateur
    id_competence INT NOT NULL,--Référence vers compétence

    type_competence ENUM('POINT_FORT','POINT_FAIBLE') NOT NULL,

    FOREIGN KEY(id_utilisateur)
        REFERENCES utilisateur(id_utilisateur)
        ON DELETE CASCADE,

    FOREIGN KEY(id_competence)
        REFERENCES competence(id_competence)
        ON DELETE CASCADE
);

-- ==========================
-- DISPONIBILITE
-- ==========================
CREATE TABLE disponibilite (
    id_disponibilite INT AUTO_INCREMENT PRIMARY KEY,--Identifiant unique

    id_utilisateur INT NOT NULL,--Référence utilisateur

    jour ENUM(
        'LUNDI',
        'MARDI',
        'MERCREDI',
        'JEUDI',
        'VENDREDI',
        'SAMEDI',
        'DIMANCHE'
    ) NOT NULL,--Jour de la semaine

    heure_debut TIME NOT NULL,--Heure de début
    heure_fin TIME NOT NULL,--Heure de fin

    FOREIGN KEY(id_utilisateur)
        REFERENCES utilisateur(id_utilisateur)
        ON DELETE CASCADE
);

-- ==========================
-- OFFRE DE DISPONIBILITE
-- ==========================
CREATE TABLE offre_disponibilite (
    id_offre INT AUTO_INCREMENT PRIMARY KEY,--Identifiant unique

    id_utilisateur INT NOT NULL,--Référence vers utilisateur
    id_competence INT NOT NULL,--Matière concernée
    id_disponibilite INT NOT NULL,--Créneau horaire proposé

    format ENUM(
        'PRESENTIEL',
        'EN_LIGNE',
        'LES_DEUX'
    ) NOT NULL,--'presentiel','en_ligne','les_deux'

    type ENUM(
        'OFFRE',
        'DEMANDE'
    ) DEFAULT 'DEMANDE',--'offre' ou 'demande'

    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,--Date de publication

    FOREIGN KEY(id_utilisateur)
        REFERENCES utilisateur(id_utilisateur)
        ON DELETE CASCADE
);

-- ==========================
-- MATCHING
-- ==========================
CREATE TABLE matching (
    id_matching INT AUTO_INCREMENT PRIMARY KEY,--Identifiant unique

    mentor_id INT NOT NULL,--Référence vers utilisateur(mentor)
    mentore_id INT NOT NULL,--Référence vers utilisateur(mentor)

    score_compatibilite FLOAT NOT NULL,--Score de compatibilité (0 à 100)

    statut ENUM(
        'EN_ATTENTE',
        'ACCEPTE',
        'REFUSE'
    ) DEFAULT 'EN_ATTENTE',--'en attente','accepte','refuse'

    date_matching TIMESTAMP DEFAULT CURRENT_TIMESTAMP,--Date du matching

    FOREIGN KEY(mentor_id)
        REFERENCES utilisateur(id_utilisateur)
        ON DELETE CASCADE,

    FOREIGN KEY(mentore_id)
        REFERENCES utilisateur(id_utilisateur)
        ON DELETE CASCADE
);

-- ==========================
-- CONVERSATION
-- ==========================
CREATE TABLE conversation (
    id_conversation INT AUTO_INCREMENT PRIMARY KEY,--Indentifiant unique

    id_utilisateur1 INT NOT NULL,--Premier participant
    id_utilisateur2 INT NOT NULL,--Deuxième participant

    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,--Date de création

    FOREIGN KEY(id_utilisateur1)
        REFERENCES utilisateur(id_utilisateur)
        ON DELETE CASCADE,

    FOREIGN KEY(id_utilisateur2)
        REFERENCES utilisateur(id_utilisateur)
        ON DELETE CASCADE
);

-- ==========================
-- MESSAGE
-- ==========================
CREATE TABLE message (
    id_message INT AUTO_INCREMENT PRIMARY KEY,--Identifiant unique

    id_conversation INT NOT NULL,--Référence vers conversation
    id_expediteur INT NOT NULL,--Référence vers utilisateur

    contenu TEXT NOT NULL,--Contenu du méssage

    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,--Date et heure d'envoi

    FOREIGN KEY(id_conversation)
        REFERENCES conversation(id_conversation)
        ON DELETE CASCADE,

    FOREIGN KEY(id_expediteur)
        REFERENCES utilisateur(id_utilisateur)
        ON DELETE CASCADE
);

-- =========================
-- NOTIFICATIONS
--==========================
CREATE TABLE notifications(
    id_notification INT AUTO_INCREMENT PRIMARY KEY,--Identifiant unique
    id_utilisateur INT NOT NULL,--Référence vers utilisateur
    contenu TEXT NOT NULL,--contenu
    lu BOOLEAN DEFAULT FALSE,--lu ou pas
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,--Date et heure de réception
    
    FOREIGN KEY (id_utilisateur)
        REFERENCES utilisateur(id_utilisateur)
        ON DELETE CASCADE
);