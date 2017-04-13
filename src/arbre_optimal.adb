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
      Put(Integer'Image(A.valeur));
      if A.filsdroit/=NULL then
        Put("fils droit");
        Affiche_Arbre(A.filsdroit);
      end if;
      if A.filsgauche/=NULL then
        Put("fils gauche");
        Affiche_Arbre(A.filsgauche);
      end if;

    end Affiche_Arbre;

    procedure Affiche(T : in T_Int; A : in Arbre) is
      i : Integer;
    begin
      i := 1;
      Put_Line("static int BSTroot = " & Integer'Image(A.valeur) & ";");
      Put_Line("static int BSTtree[" & Integer'Image(T'Length) & "][2] = {");
      for i in 0..T'Length-2 loop
        Put_Line("{" & Integer'Image(T(i,0)) & "," & Integer'Image(T(i,1)) & "}, ");
      end loop;
        Put_Line("{" & Integer'Image(T(T'Length-1,0)) & "," & Integer'Image(T(T'Length-1,1)) & "} };");

    end Affiche;



function Construit_Abr_Optimal(i : Integer; j : Integer; R : in T_Int) return Arbre is
  A : Arbre ;
begin
  A := creer_arbre(R(i,j));
  if(i < R(i,j)-1) then
    A.filsgauche:= Construit_Abr_Optimal(i, R(i,j)-1,R);
  end if;
  if(R(i,j)<j) then
    A.filsdroit:= Construit_Abr_Optimal(R(i,j),j,R);
  end if;
  return A;
end Construit_Abr_Optimal;

procedure Parcourir_Abr_Optimal(A:in Arbre; T : in out T_Int) is    -- cette procédure recursive permet de réecrire l'arbre dans un programme.
begin

  if(A.filsgauche = NULL) then
    T(A.valeur,0):=-1;
  end if;
  if(A.filsdroit = NULL) then
    T(A.valeur,1):=-1;
  end if;

if A.filsgauche/=NULL then
  T(A.valeur,0):= A.filsgauche.valeur;
  Parcourir_Abr_Optimal(A.filsgauche,T);
end if;
if A.filsdroit/=NULL then
  T(A.valeur,1):= A.filsdroit.valeur;
  Parcourir_Abr_Optimal(A.filsdroit,T);
end if;

end Parcourir_Abr_Optimal;


end Arbre_Optimal;
