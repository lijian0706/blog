### 依赖
```
<dependency>
	<groupId>commons-net</groupId>
	<artifactId>commons-net</artifactId>
	<version>3.6</version>
</dependency>
```
### 代码
- `FTPFileWriter`
```
package com.lijian.ftpclient;

/**
 * @Author: Lijian
 * @Date: 2019-08-13 10:05
 */

import org.apache.commons.net.ftp.FTP;
import org.apache.commons.net.ftp.FTPClient;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;

public class FTPFileWriter {

    private FTPConfig ftpConfig;

    public FTPFileWriter(FTPConfig ftpConfig){
        this.ftpConfig = ftpConfig;
    }

    public Boolean upload(){
        FTPClient ftpClient = new FTPClient();
        try {
            ftpClient.connect(ftpConfig.getServer(), ftpConfig.getPort());
            ftpClient.login(ftpConfig.getUsername(), ftpConfig.getPassword());
            ftpClient.enterLocalPassiveMode();
            ftpClient.setFileType(FTP.BINARY_FILE_TYPE);

            File file = new File(ftpConfig.getLocalPath());
            InputStream inputStream = new FileInputStream(file);
            Boolean mkdResult = ftpClient.makeDirectory(ftpConfig.getRemotePath());
            Boolean result = ftpClient.storeFile(ftpConfig.getRemotePath() + file.getName(), inputStream);
            inputStream.close();
            System.out.println(result);
        } catch (IOException ex) {
            System.out.println("Error: " + ex.getMessage());
            ex.printStackTrace();
            return false;
        } finally {
            try {
                if (ftpClient.isConnected()) {
                    ftpClient.logout();
                    ftpClient.disconnect();
                }
            } catch (IOException ex) {
                ex.printStackTrace();
                return false;
            }
        }
        return true;
    }

    public static void main(String[] args) {
        String server = "192.168.1.20";
        int port = 21;
        String user = "username";
        String pass = "password";

        FTPConfig ftpConfig = new FTPConfig();
        ftpConfig.setServer(server);
        ftpConfig.setPort(port);
        ftpConfig.setUsername(user);
        ftpConfig.setPassword(pass);
        ftpConfig.setRemotePath("/clipcloud/ftp/music/2/");
        ftpConfig.setLocalPath("/Users/LEO/Downloads/1547537427064_sc99_01.mp4");
        FTPFileWriter ftpFileWriter = new FTPFileWriter(ftpConfig);
        ftpFileWriter.upload();
    }
}
```

- `FTPConfig`
```
package com.lijian.ftpclient;

import lombok.Data;

/**
 * @Author: Lijian
 * @Date: 2019-08-12 16:15
 */
@Data
public class FTPConfig {
    private String server;
    private String username;
    private String password;
    private int port;
    private String remotePath;
    private String localPath;
}
```