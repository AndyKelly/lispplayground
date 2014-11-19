(defparameter *nodes* '((living-room (you are in the living-room.
							a wizard is snoring loudly on the couch))
						(garden (you are in a beautiful garden
									there is a well in front of you))
						(attic ( you are in the attic.
								there is a giant wielding a torch in the corner))))

(defun describe-location (location nodes)
	(cadr(assoc location nodes)))

(defparameter *edges* '((living-room (garden west door)
										(attic upstairs ladder))
						(garden (living-room east door))
						(attic (living-room downstairs ladder))))

(defun describe-path (edge)
	`(there is a ,(caddr edge) going ,(cadr edge) from here.))

(defun describe-paths (location edges)
	(apply #'append (mapcar #'describe-path (cdr (assoc location edges)))))

(defun describe-in-sight (location *edges*)
	(cons (describe-location 'attic *nodes*) (describe-paths 'attic *edges*)))

(defparameter *objects* '(whiskey bucket frog chain))

(defparameter *object-locations* '((whiskey living-room)
                                   (bucket living-room)
                                   (chain garden)
                                   (frog garden)))

(defun objects-at (loc objs obj-loc)
   (labels ((is-at (obj)
              (eq (cadr (assoc obj obj-loc)) loc)))
       (remove-if-not #'is-at objs)))

(defun describe-objects (loc objs obj-loc)
		(labels ( (describe-obj (obj)
			`(you see a ,obj on the floor.)))
		(apply #'append (mapcar #'describe-obj (objects-at loc objs obj-loc)))))



(defun look ()
	(append (describe-location *location* *nodes*)
		(describe-paths *location* *edges*)
		(describe-objects *location* *objects* *object-locations*)))

(defun walk (direction)
	(let ((next (find direction 
			(cdr (assoc *location* *edges*))
			:key #'cadr)))
	(if next
			(progn (setf *location* (car next))
				(look))
			'(you cannot go that way.))))

(defun pickup (object)
	(cond (( member object 
			(objects-at *location* *objects* *object-locations*))
		(push (list object 'body) *object-locations*)
			`(you are now carrying the , object))
		(t '(stop right there criminal scum you cannot get that.))))

(defun inventory () 
	(cons 'items- (objects-at 'body *objects* *object-locations*)))

(defun say-hello ()
	(princ "Please type your name >")
	(let ((name (read)))
		(princ "Nice to meet you, ")
		(princ name)))

(defun game-repl ()
	(loop 
		(progn  
			(print (eval (read))) 
			(princ #\newline) 
			(princ "Now what should we do?") 
		)
	)
)

(defun game-repl ()
	(let ((cmd (game-read)))
		(unless (eq car cmd) 'quit)
			(game-print (game-eval cmd))
			(game-repl)))

(defun game-read ()
	(let ((cmd (read-from-string
		(concatenate 'string "(" (read-line) ")"))))
		(flet ((quote-it (x) 
							(list 'quote x )))
			(cons (car cmd) (mapcar #'quote-it (cdr cmd))))))

#(print (describe-in-sight 'attic *edges*))

#(print(apply #'append '((There is a door going west from here.)(There is a ladder going upstairs from here.))))

#(print (objects-at 'living-room *objects* *object-locations*))
#(print(describe-objects 'living-room *objects* *object-locations*))



(defparameter *location* 'garden)
(print (look))
(walk 'east)
