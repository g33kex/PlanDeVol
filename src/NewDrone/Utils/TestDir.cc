#include "TestDir.h"
#include "AppSettings.h"
#include <QDir>

extern AppSettings* sett;

TestDir::TestDir()
{

}

void TestDir::test(){
    QDir savePathDir(sett->savePath()->rawValue().toString());
    if (!savePathDir.exists()) {
        QDir().mkpath(savePathDir.absolutePath());
    }
}
