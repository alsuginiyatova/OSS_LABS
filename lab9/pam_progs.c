#include </usr/include/security/pam_appl.h>
#include </usr/include/security/pam_misc.h>
#include <stdio.h>

static struct pam_conv conv = {
	misc_conv,
	NULL
};

int main(int argc, char* argv[]){
	pam_handle_t* pamh;
	int errnum;

	int rvalue;
	const char* user = "nobody";
    
	if(argc == 2){
	    user = argv[1];
	}

	if(argc != 2){
        fprintf(stderr, "Usage: %s [username]\n", argv[0]);
        return 2;
	}

	rvalue = pam_start("check", user, &conv, &pamh);

	if(rvalue == PAM_SUCCESS) {
        rvalue = pam_authenticate(pamh, 0);
		printf("authenticate error code: %s\n", pam_strerror(pamh, rvalue));
    }

    if(rvalue == PAM_SUCCESS){
       	rvalue = pam_acct_mgmt(pamh, 0);
		printf("acct_mgmt error code: %s\n", pam_strerror(pamh, rvalue));
    }

    if(rvalue == PAM_SUCCESS){
       	fprintf(stdout, "AUTH SUCCESSFUL\n");
    }
     
    if(rvalue != PAM_SUCCESS){
       	fprintf(stdout, "AUTH FAILURE\n");
    }

	if(pam_end(pamh,rvalue) != PAM_SUCCESS){
        pamh = NULL;
        fprintf(stderr, "Check user: failed to release authenticator ");
        return 3;
	}

	return (rvalue == PAM_SUCCESS ? 0 : 1);
}
