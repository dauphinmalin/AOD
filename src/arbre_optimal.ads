with Ada.Streams.Stream_IO; use Ada.Streams.Stream_IO;
-- paquetage representant un ABR optimal de caracteres

package Arbre_Optimal is

	type Arbre is private;
	type Fils is array(0..1) of Integer;
  type T_Int is array(Integer range <>,Integer range <>) of Integer;

	type Arbre_Optimal is record
		-- l'arbre optimal proprement dit
		A : Arbre;
		-- autres infos utiles: nb total de caracteres lus, ...
		Nb_Total_Elements : Natural;
	end record;

	function creer_arbre(I : Integer) return Arbre;
	procedure Libere_Arbre(A: in out Arbre);
	procedure Libere(AbrO : in out Arbre_Optimal);
	procedure Affiche_Arbre(A:in Arbre);

	function Construit_Abr_Optimal(i : Integer; j : Integer; R : in T_Int) return Arbre;

	procedure Parcourir_Abr_Optimal(A : in Arbre; T : in out T_Int ) ;
	    procedure Affiche(T : in T_Int; N : in Integer; A : in Arbre) ;
private

	-- type Noeud prive: a definir dans le body du package, AbrOptimal.adb
	type Noeud;


	type Arbre is Access Noeud;

end Arbre_Optimal;
