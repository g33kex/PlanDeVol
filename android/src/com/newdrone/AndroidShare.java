package com.newdrone;

import java.lang.String;
import java.net.URLConnection;
import java.io.File;
import android.net.Uri;
import android.content.Intent;
import android.support.v4.content.FileProvider;
import android.content.Context;

import android.util.Log;

import org.qtproject.qt5.android.QtNative;

public class AndroidShare
{
    protected AndroidShare()
    {
    }

    public static void share(String text, String url, Context context) {
        Log.d("NewDrone", "In share !");
        if (QtNative.activity() == null)
            return;        
       /* Intent intentShareFile = new Intent(Intent.ACTION_SEND);

        intentShareFile.setType("text/xml");
        intentShareFile.putExtra(Intent.EXTRA_STREAM, Uri.parse("file://"+url));
        intentShareFile.addFlags(Intent.FLAG_GRANT_WRITE_URI_PERMISSION);

        //if you need
        intentShareFile.putExtra(Intent.EXTRA_SUBJECT,text);

        QtNative.activity().startActivity(Intent.createChooser(intentShareFile, "Share File"));*/

        Intent shareIntent = new Intent(Intent.ACTION_SEND);
        shareIntent.setType("text/xml");
        shareIntent.addFlags(Intent.FLAG_GRANT_READ_URI_PERMISSION);
        shareIntent.addFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP);
        shareIntent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
        shareIntent.putExtra(Intent.EXTRA_SUBJECT, "Share Parcel");
        File file = new File(url);
        if(file.exists()) {
            Log.d("NewDrone", "File exists with url "+url+" and absolute path "+file.getAbsolutePath());

            Uri fileURI = FileProvider.getUriForFile(context, "org.newdrone.flightplan.fileprovider", file);
            shareIntent.putExtra(Intent.EXTRA_STREAM, fileURI);

            if (shareIntent.resolveActivity(QtNative.activity().getPackageManager()) != null) {
                       QtNative.activity().startActivity(shareIntent);
                   } else {
                       Log.d("NewDrone", "Intent not resolved");
                   }
        }
        else {
            Log.d("NewDrone", "File doesn't exist with url "+url+" and absolute path "+file.getAbsolutePath());
        }
    }
}
