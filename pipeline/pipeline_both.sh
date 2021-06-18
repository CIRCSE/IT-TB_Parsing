python tree_combiner_no_weigth.py tested_MLP_R-to-L.conll tested_SVM_R-to-L.conll tested_MLP_L-to-R.conll ics_thom-sent_tested.conll tested_thom-sent_turku.conll > combined-both.conll

python conllx_evaluator.py combined-both.conll Treebank_Test.conll
