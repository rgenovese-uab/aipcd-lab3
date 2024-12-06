
CV_RTL_NAME   ?= Vector_Accelerator
CV_RTL_REPO   ?= git@repo.hca.bsc.es:EPI/RTL/Vector_Accelerator.git
CV_RTL_BRANCH ?= develop
CV_RTL_TAG    ?= none
CV_RTL_PKG    ?= ${VERIF}/rtl/${CV_RTL_NAME}

export DESIGN_RTL_DIR ?= ${CV_RTL_PKG}


clone_rtl:
	git clone ${CV_RTL_REPO} ${CV_RTL_PKG} --recurse-submodules -b develop

update_rtl:
	git --git-dir ${CV_RTL_PKG}/.git pull --recurse-submodules -j 4
