#!/usr/bin/env python

# Copyright (C) 2017  Halim Burak Yesilyurt <h.burakyesilyurt@gmail.com>

import urllib2, zipfile,os.path,distutils.dir_util,shutil

url = "https://verge-blockchain.com/blockchain/Wallet_v3.0_Verge-Blockchain_2017-December-31.zip"
file_name = "~/Desktop/verge_blockchain.zip"
dir_name = "~/Desktop/temp_verge/"
app_support_folder = "~/Library/Application Support/VERGE/"

'''
Function : downloadAndSaveVergeBlockchain
It retrives latest blockchain zip file from server and it saves blockchain zip file to user's desktop folder.
'''
def downloadAndSaveVergeBlockchain():
    u = urllib2.urlopen(url)
    f = open(os.path.expanduser(file_name), 'wb')
    meta = u.info()
    file_size = int(meta.getheaders("Content-Length")[0])
    print "Downloading VERGE blockchain: %s Bytes: %s" % (os.path.expanduser(file_name), file_size)

    file_size_dl = 0
    block_sz = 8192
    while True:
        buffer = u.read(block_sz)
        if not buffer:
            break

        file_size_dl += len(buffer)
        f.write(buffer)
        status = r"%10d  [%3.2f%%]" % (file_size_dl, file_size_dl * 100. / file_size)
        status = status + chr(8)*(len(status)+1)
        print status,

    f.close()
'''
Function : unzipBlockchain
It unzips downloaded file into temp_verge folder, after that it removes blockhain zip file in order to save disk space.
'''
def unzipBlockchain():
    zip_ref = zipfile.ZipFile(os.path.expanduser(file_name))
    if not os.path.exists(os.path.expanduser(dir_name)):
        os.makedirs(os.path.expanduser(dir_name))
    os.chdir(os.path.expanduser(dir_name))
    print "Verge Blockchain Zip File is Extracting..."
    zip_ref.extractall(os.path.expanduser(dir_name))
    zip_ref.close()
    os.remove(os.path.expanduser(file_name))
'''
Function : copyFile2AppSupportFolder
It copies extracted blockchain folder into ~/Library/Application\ Support//VERGE/ folder as it is suggested on the verge blockchain web-site.
'''
def copyFile2AppSupportFolder():
    distutils.dir_util.copy_tree(os.path.expanduser(dir_name), os.path.expanduser(app_support_folder))
    print "Copying extracted file.."
    shutil.rmtree(os.path.expanduser(dir_name))

downloadAndSaveVergeBlockchain()
unzipBlockchain()
copyFile2AppSupportFolder()
