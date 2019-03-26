import string
import random


def random_string(size=12):
    chars = string.ascii_uppercase + string.ascii_lowercase + string.digits
    return ''.join(random.choice(chars) for _ in range(size))


users = ["acsuser", "basisuser", "cmfuser", "certuser", "counteruser",
        "csauser", "dpmuser", "ffsuser", "fosuser", "guardianuser", "lfltuser",
        "memberuser", "mnsuser", "ossuser", "paymentuser", "pbsuser", "pfsuser",
        "rmsuser", "tssuser", "voucheruser", "uesuser", "reader",
        "smsgatewayuser", "auzuser", "pbsuser", "otcuser", "blockchainbtc"]


def create_user_passwd_sql(file):
    for user in users:
        with open(file, 'a') as f:
            f.write("update mysql.user set authentication_string=password('%s') where User='%s';\n" % (random_string(size=12), user))


if __name__ == "__main__":
    create_user_passwd_sql("otc.sql")