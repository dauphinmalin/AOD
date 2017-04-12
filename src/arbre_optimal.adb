with Ada.Integer_Text_Io; use Ada.Integer_Text_Io;
with Ada.Text_Io; use Ada.Text_Io;
with Ada.Unchecked_Deallocation;
-- Exemple de lecture/ecriture de donnes dans un fichier,
-- a l'aide de flux Ada.

with Ada.Streams.Stream_IO; use Ada.Streams.Stream_IO;
package body Arbre_Optimal is

  type Noeud is record
    valeur: Integer;
    filsgauche: Arbre;
    filsdroit : Arbre;
  end record;



  procedure Free is new Ada.Unchecked_Deallocation (Noeud,Arbre);

  --package File_Priorite_Arbre_Optimal is
  --  new File_Priorite(Arbre_Optimal,Integer,"=","<");
  --  use File_Priorite_Arbre_Optimal;
  --
  --  type Octet is new Integer range 0 .. 255;
  --  for Octet'Size use 8; -- permet d'utiliser Octet'Input et Octet'Output,
  --  -- pour lire/ecrire un octet dans un flux


    function creer_arbre(I: Integer) return Arbre is       --Cree un Arbre
      A:Arbre:=new Noeud;
    begin
      A.valeur:=I;
      A.filsgauche:=NULL;
      A.filsdroit:=NULL;
      return A;
    end creer_arbre;


    procedure Libere_Arbre(A : in out Arbre) is       -- libere l'Arbre
    begin
      if (A.filsgauche/=NULL) then
        Libere_Arbre(A.filsgauche);
      end if;
      if (A.filsdroit/=NULL) then
        Libere_Arbre(A.filsdroit);
      end if;
      free(A);
    end Libere_Arbre;

    procedure Libere(AbrO: in out Arbre_Optimal) is
    begin
      Libere_Arbre(AbrO.A);
    end Libere;

    procedure Affiche_Arbre(A:in Arbre) is      -- fonction recursive pour parcourir l'arbre Affiche a juste à l'appeler;
    begin
      if A.filsdroit/=NULL then
        Affiche_Arbre(A.filsdroit);
      end if;
      if A.filsgauche/=NULL then
        Affiche_Arbre(A.filsgauche);
      end if;
      if A.filsgauche=NULL and A.filsdroit=NULL then
        Put(Integer'Image(A.valeur));
      end if ;
    end Affiche_Arbre;


    procedure Affiche(AbrO:in Arbre_Optimal) is

    begin
      Put_Line("");
      Affiche_Arbre(AbrO.A);
      Put_Line("");
    end Affiche;


    -- Lit dans un fichier ouvert en lecture, et affiche les valeurs lues




  -- Stocke un arbre dans un flux ouvert en ecriture
  -- Le format de stockage est celui decrit dans le sujet
  -- Retourne le nb d'octets ecrits dans le flux (pour les stats)

  procedure Ecrit_Arbre(A:in Arbre;Flux : Ada.Streams.Stream_IO.Stream_Access) is    -- cette procédure recursive permet de réecrire l'arbre dans un programme.
begin
  if A.filsgauche/=NULL then
    Ecrit_Arbre(A.filsgauche,Flux);
  end if;
  if A.filsdroit/=NULL then
    Ecrit_Arbre(A.filsdroit,Flux);
  end if;


  if A.filsgauche=NULL and A.filsdroit=NULL then
    Integer'Output(Flux,A.valeur);

  end if ;
end Ecrit_Arbre;


function Ecrit_Optimal(AbrO : in Arbre_Optimal;Flux : Ada.Streams.Stream_IO.Stream_Access)
return Positive is
begin

  Natural'Output(Flux,AbrO.Nb_Total_Elements);   -- permet de savoir quand il on a atteint la fin de l'abre lors de l'ouverture du fichier compressé.
  Put("Ecriture des donnees: ");
  Ecrit_Arbre(AbrO.A,Flux);
  return 1;
end Ecrit_Optimal;

function Construit_Abr_Optimal(i : Integer; j : Integer; R : in T_Int) return Arbre is
  A : Arbre ;
begin
  A := creer_arbre(R(i,j));
  Affiche_Arbre(A);
  if(i < R(i,j)-1) then
    A.filsgauche:= Construit_Abr_Optimal(i, R(i,j)-1,R);
  end if;
  if(R(i,j)<j) then
    A.filsdroit:= Construit_Abr_Optimal(R(i,j),j,R);
  end if;
  return A;
end Construit_Abr_Optimal;

--Lit un arbre stocke dans un flux ouvert en lecture
-- Le format de stockage est celui decrit dans le sujet
--function Lit_Optimal(Flux : Ada.Streams.Stream_IO.Stream_Access)
--return Arbre_Optimal is
--  Nb_caractere:Natural;
--  T : array(0..256) of cellule;     -- tableau dont le nombre de case correspont à la representation décimale des Characters
--  i:Natural:=0;
--  F:File_Prio:=Cree_File(256);    --file prioritaire pour la creation de l'arbre
--  C:Character;
--  Prio:Integer;
--  Optimal,moins_prio1,moins_prio2 : Arbre_Optimal;      --elements intermedaires pour la fusion des arbres
--  prio1,prio2:Integer;                  -- elements facilitants l'utilisation des fonctions de file_priorite
--begin
--  for j in 0..256 loop
--    T(j).Prio:=0;
--  end loop;
--  Nb_caractere:=Natural'Input(Flux);  --ce nombre permet de savoir quand on doit arreter de lire le fichier
--  while(i<Nb_caractere) loop --boucle tant qu'on a pas atteint le nombre de caractere
--    C:=Character'Input(Flux);
--    T(Character'Pos(C)).Data:=C;
--    Prio:=Integer'Input(Flux);
--    T(Character'Pos(C)).Prio:=Prio;
--    i:=i+Prio;
--  end loop;
--  for j in 0..256 loop -- on crée la file_priorite à partir du tableau nous nous sommes rendus compte trop tard
--    if T(j).Prio>0 then --que l'utilisation du type tableau dès le départ s'avairait plus malin dans ce cas
--      Optimal.A:=creer_arbre(T(j).Data,T(j).Prio);
--
--      Optimal.Nb_Total_Caracteres:=T(j).Prio;
--      Insere(F,Optimal,T(j).Prio); -- on insere que ceux dont la priorite est superieure à 0 cad ils sont présents
--    end if;
--  end loop;
--
--  while(Get_Taille(F)>1) loop     -- creation de l'arbre
--    Supprime(F,moins_prio1,prio1);
--    Supprime(F,moins_prio2,prio2);
--    Fusion_Arbre(moins_prio1,moins_prio2); -- fusion des deux arbres les plus petits
--    Insere(F,moins_prio1,moins_prio1.Nb_Total_Caracteres);
--
--  end loop;
--  Supprime(F,moins_prio1,prio1);
--  return moins_prio1;
--end Lit_Optimal;

------ Parcours de l'arbre (decodage)

-- Parcours a l'aide d'un iterateur sur un code, en partant du noeud A
--  * Si un caractere a ete trouve il est retourne dans Caractere et
--    Caractere_Trouve vaut True. Le code n'a eventuellement pas ete
--    totalement parcouru. A est une feuille.
--  * Si l'iteration est terminee (plus de bits a parcourir ds le code)
--    mais que le parcours s'est arrete avant une feuille, alors
--    Caractere_Trouve vaut False, Caractere est indetermine
--    et A est le dernier noeud atteint.
--procedure Get_Caractere(It_Code : in Iterateur_Code; A : in out Arbre;
--    Caractere_Trouve : out Boolean;
--  Caractere : out Character);


end Arbre_Optimal;
