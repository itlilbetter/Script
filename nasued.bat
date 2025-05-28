@echo off
:: 设置主机信息（NAS 先，UED 后）
set USER_NAS=temp
set PASS_NAS=ihQbR*
set HOST_NAS=192.168.10.255

set USER_UED=shengzai
set PASS_UED=69G-Iy
set HOST_UED=192.168.10.158

:: 删除已有的映射盘符
net use Z: /delete /yes
net use X: /delete /yes

:: 删除旧的登录凭据
cmdkey /delete:%HOST_NAS%
cmdkey /delete:%HOST_UED%

:: 添加新的登录凭据（加引号以防特殊字符）
cmdkey /add:%HOST_NAS% /user:"%USER_NAS%" /pass:"%PASS_NAS%"
cmdkey /add:%HOST_UED% /user:"%USER_UED%" /pass:"%PASS_UED%"

:: 映射网络驱动器
net use Z: "\\%HOST_NAS%\nas" /persistent:yes
net use X: "\\%HOST_UED%\ued" /persistent:yes

:: 成功提示
echo.
echo ✅ 网络驱动器映射完成：
echo   NAS 映射为 Z:
echo   UED 映射为 X:
pause
