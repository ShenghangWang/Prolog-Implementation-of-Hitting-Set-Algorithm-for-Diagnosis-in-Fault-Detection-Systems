% Shenghang Wang, Sophie van Liempt, Yitsz Neurink
% Make Hitting Tree Part
------------------------
makeChildren_helper(SD, COMP, OBS, S, H, Result) :-
    S = [],
    Result = [];
    S = [X|Tail],
    makeChildren_helper(SD, COMP, OBS, Tail, H, Rest),
    makeHittingTree_helper(SD, COMP, OBS, [X|H], Tree),
    Result = [[X, Tree]|Rest].

makeHittingTree_helper(SD, COMP, OBS, H, Tree) :-
    not(tp(SD, COMP, OBS, H, CS)),
    Tree = [];
    tp(SD, COMP, OBS, H, CS),
    makeChildren_helper(SD, COMP, OBS, CS, H, Children),
    Tree = Children. 

makeHittingTree(SD, COMP, OBS, Tree) :-
    makeHittingTree_helper(SD, COMP, OBS, [], Tree).

% Gather Diagnoses Part
------------------------
children(Parents, Children, Result) :-
    Children = [[]],
    Result = [Parents];
    Children = [H|T],
    H = [Child|OtherChildren],
    parent(Child, Parents, R1),
    children(Parents, [OtherChildren], R2),
    append(R1, R2, Result). 

parent(Tree, Diagnosis, Result) :-
    Tree = [],
    Result = [];
    Tree = [Parent|Children],
    append(Diagnosis, [Parent], Parents),
    children(Parents, Children, Result).

gatherDiagnoses(Tree, Diagnoses) :-
    Tree = [],
    Diagnoses = [];
    Tree = [FirstNode|RestTree],
    parent(FirstNode, [], Result1),
    gatherDiagnoses(RestTree, Result2),
    append(Result1, Result2, Diagnoses).

% Get Minimal Diagnoses Part
----------------------------
getMinimalDiagnoses([], []).
getMinimalDiagnoses([D|Ds], MDL) :-
    (select(S, Ds, D1),
     ord_subset(D, S)
    -> getMinimalDiagnoses([D|D1], MDL);
    MDL = [D|D2],
    getMinimalDiagnoses(Ds, D2)).

% Hitting Set Algorithm
-----------------------------
hittingSet(SD, COMP, OBS, HittingSets) :-
    makeHittingTree(SD, COMP, OBS, Tree),
    gatherDiagnoses(Tree, Diagnoses),
    getMinimalDiagnoses(Diagnoses, HittingSets).











