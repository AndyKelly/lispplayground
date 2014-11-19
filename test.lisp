(defun main()
	(print(+ 55 55))
)

(defun my-length (list)
	(if list
		(1+ (my-length (cdr list) ) )
		0))

(print(my-length '(list with four symbols)))


(print '(Printing out a list))
(print "Printing a string")

(print(eq '() nil))
(print (eq '() ()))
(print(eq '() 'nil))


(print(if (= (+ 2 3) 5)
	'yup
	'nope) )

(defvar *numberwasodd* nil)

(if (oddp 5)
	(progn (setf *numberwasodd* "Im a string that got instantiated by piggy backing on the if")
		'odd)
	'even)

(print *numberwasodd*)


(defvar *global* nil)
(when (oddp 5)
	(setf *global* "Global got set in when")
	'odd-number)

(print *global*)



(defvar *global* nil)
(unless (oddp 4)
	(setf *global* "Global got set in unless")
	'odd-number)

(print *global*)


(defvar *arch-enemy* nil)

(defun pudding-eater (person)
	(cond ((eq person 'henry) (setf *arch-enemy* 'stupid-lisp-alien)
		'(curse you alien - you ate my pudding))
		((eq person 'johnny) (setf *arch-enemy* 'usless-old-johnny)
			'(I hope you choked on my puding jhonny))
		(t '(why you eat my pudding stranger?))))

(print(pudding-eater 'joe))
(print *arch-enemy*)