with Ada.Integer_Text_Io; use Ada.Integer_Text_Io;
with Ada.Text_Io; use Ada.Text_Io;
with Ada.Unchecked_Deallocation;
with file_priorite;
-- Exemple de lecture/ecriture de donnes dans un fichier,
-- a l'aide de flux Ada.

with Ada.Streams.Stream_IO; use Ada.Streams.Stream_IO;
package body Arbre_Optimal is

  type Noeud is record
    valeur: Integer;
    proba : Flaot;
    filsgauche: Arbre;
    filsdroit : Arbre;
  end record;

  procedure Free is new Ada.Unchecked_Deallocation (Noeud,Arbre);

  package File_Priorite_Arbre_Optimal is
    new File_Priorite(Arbre_Optimal,Integer,"=","<");
    use File_Priorite_Arbre_Optimal;

    type Octet is new Integer range 0 .. 255;
    for Octet'Size use 8; -- permet d'utiliser Octet'Input et Octet'Output,
    -- pour lire/ecrire un octet dans un flux


    function creer_arbre(C: Character;p: Float) return Arbre is       --Cree un Arbre
      A:Arbre:=new Noeud;
    begin
      A.valeur:=C;
      A.proba:=p;
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
        Put(Integer'Image(A.proba));
      end if ;
    end Affiche_Arbre;


    procedure Affiche(AbrO:in Arbre_Optimal) is

    begin
      Put_Line("");
      Affiche_Arbre(AbrO.A);
      Put_Line("");
    end Affiche;


    -- Lit dans un fichier ouvert en lecture, et affiche les valeurs lues

    function Mise_En_Place_Optimal(Nom_Fichier : in String, n : Integer) return Arbre_Optimal is
      Fichier : Ada.Streams.Stream_IO.File_Type;
      Flux : Ada.Streams.Stream_IO.Stream_Access;
      S : Integer; --sommes de tous les entiers contenus dans le fichier (sommes des proba)
      P : array(0..n-1) of Integer; -- ce tableau sert à faire un premier enregistrement des characters présents dans le fichier
      C : array(1..n,1..n) of Float ;
      W : array(1..n,1..n) of Float ;
      R : array(1..n,1..n) of Float ;
      j : Integer;
      Cmin : Integer;
      m := Integer;
    begin
      S := 0;
      I := 0;
      for j in 0..n-1 loop
        P(j):=0;
        C(j,j):=0;
        W(j,j):=0;
      end loop;
      Open(Fichier, In_File, Nom_Fichier);
      Flux := Stream(Fichier);

      Put("Lecture des donnees: ");

      --Put(Integer'Input(Flux));
      --Put(", ");
      --Put(Integer(Octet'Input(Flux))); -- cast necessaire Octet -> Integer

      -- lecture tant qu'il reste des caracteres
      while not End_Of_File(Fichier) or I <= n-1 loop -- on lit le fichier
        I := I + 1; --indice correspondant à l'entiers
        P(I):=Integer'Input(Flux);; -- Ajout de la proba dans le tableau
        S := S + P(I); -- MaJ de la somme des proba
      end loop;

      Close(Fichier);
      Put_Line("fermeture du fichier");

      for l in 0..n-1 loop
        P(j):=P(j)/S;
      end loop;

      for l in 1..n loop
        for i in 0..n-1 loop
          j:= i+l;
          W(i,j):=W(i,j-1)+P(j);
          Cmin := C(i,j);
          for k in i..j loop
            if(C(i,k-1)+C(k,j) < Cmin) loop
              Cmin := C(i,k-1)+C(k,j);
              m := k;
            end loop;
          C(i,j):=W(i,j)+C(i,m-1)+C(m,j);
          R(i,j):= m;
          end loop;
        end loop;
      end loop;
  end Mise_En_Place_Optimal;

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
    Character'Output(Flux,A.valeur);
    Integer'Output(Flux,A.occurence);

  end if ;
end Ecrit_Arbre;


function Ecrit_Optimal(AbrO : in Arbre_Optimal;Flux : Ada.Streams.Stream_IO.Stream_Access)
return Positive is
begin

  Natural'Output(Flux,AbrO.Nb_Total_Caracteres);   -- permet de savoir quand il on a atteint la fin de l'abre lors de l'ouverture du fichier compressé.
  Put("Ecriture des donnees: ");
  Ecrit_Arbre(AbrO.A,Flux);
  return 1;
end Ecrit_Optimal;

--Lit un arbre stocke dans un flux ouvert en lecture
-- Le format de stockage est celui decrit dans le sujet
function Lit_Optimal(Flux : Ada.Streams.Stream_IO.Stream_Access)
return Arbre_Optimal is
  Nb_caractere:Natural;
  T : array(0..256) of cellule;     -- tableau dont le nombre de case correspont à la representation décimale des Characters
  i:Natural:=0;
  F:File_Prio:=Cree_File(256);    --file prioritaire pour la creation de l'arbre
  C:Character;
  Prio:Integer;
  Optimal,moins_prio1,moins_prio2 : Arbre_Optimal;      --elements intermedaires pour la fusion des arbres
  prio1,prio2:Integer;                  -- elements facilitants l'utilisation des fonctions de file_priorite
begin
  for j in 0..256 loop
    T(j).Prio:=0;
  end loop;
  Nb_caractere:=Natural'Input(Flux);  --ce nombre permet de savoir quand on doit arreter de lire le fichier
  while(i<Nb_caractere) loop --boucle tant qu'on a pas atteint le nombre de caractere
    C:=Character'Input(Flux);
    T(Character'Pos(C)).Data:=C;
    Prio:=Integer'Input(Flux);
    T(Character'Pos(C)).Prio:=Prio;
    i:=i+Prio;
  end loop;
  for j in 0..256 loop -- on crée la file_priorite à partir du tableau nous nous sommes rendus compte trop tard
    if T(j).Prio>0 then --que l'utilisation du type tableau dès le départ s'avairait plus malin dans ce cas
      Optimal.A:=creer_arbre(T(j).Data,T(j).Prio);

      Optimal.Nb_Total_Caracteres:=T(j).Prio;
      Insere(F,Optimal,T(j).Prio); -- on insere que ceux dont la priorite est superieure à 0 cad ils sont présents
    end if;
  end loop;

  while(Get_Taille(F)>1) loop     -- creation de l'arbre
    Supprime(F,moins_prio1,prio1);
    Supprime(F,moins_prio2,prio2);
    Fusion_Arbre(moins_prio1,moins_prio2); -- fusion des deux arbres les plus petits
    Insere(F,moins_prio1,moins_prio1.Nb_Total_Caracteres);

  end loop;
  Supprime(F,moins_prio1,prio1);
  return moins_prio1;
end Lit_Optimal;

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
