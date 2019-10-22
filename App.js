/**
 * 极验OneLogin展示页面
 */
import React, { Component } from 'react';
import {
  SafeAreaView,
  StyleSheet,
  ScrollView,
  View,
  Text,
  StatusBar,
  Button,
  TouchableOpacity
} from 'react-native';

import {
  Header,
  LearnMoreLinks,
  Colors,
  DebugInstructions,
  ReloadInstructions,
} from 'react-native/Libraries/NewAppScreen';

import onelogin from './src/onelogin';
import Orientation from 'react-native-orientation';

import { NativeModules } from 'react-native'

// Android

/*const onPressButton = () => {
    onelogin.requestToken().then(data => {
        console.log("获取手机号成功:", data);
    }).catch((code, message) => {
        switch (code) {
            case '0':
                console.log("预取号失败:", message);
                break;
            case '1':
                console.log("取号失败:", message);
                break;
            case '2':
                console.log("获取手机号失败:", message);
                break;
        }
    });

};

export default class App extends Component {
    constructor(props) {
        super(props);
    }

    // 在组件绘制完成之后,设置屏幕方向为竖屏
    componentDidMount() {
        Orientation.lockToPortrait();
    }


    render() {
        return (
            <View style={styles.container}>
                <Text style={styles.welcome}>
                    Welcome to OneLogin!
                </Text>
                <TouchableOpacity onPress={onPressButton}>
                    <View style={{borderWidth: 1, borderColor: '#CCCCCC', padding: 10}}>
                        <Text>Trigger OneLogin</Text>
                    </View>
                </TouchableOpacity>
            </View>
        );
    }
}*/

// iOS
const OneLoginUtil = NativeModules.OneLoginUtil;

export default class OneLoginApp extends Component {
    onNormalPress() {
      console.log('You tapped the normal button!');
      OneLoginUtil.normalLogin();
    }
  
    onPopupPress() {
      console.log('You tapped the popup button!');
      OneLoginUtil.popupLogin();
    }
  
    onFloatWindowPress() {
      console.log('You tapped the float window button!');
      OneLoginUtil.floatWindowLogin();
    }
  
    onLandscapePress() {
      console.log('You tapped the landscape button!');
      OneLoginUtil.landscapeLogin();
    }
  
    render() {
      return (
        <View style={styles.ioscontainer}>
          <View style={styles.navigationBar}>
            <Text style={styles.navigationTitle}>
              OneLoginRN
            </Text>
          </View>
          <View style={styles.buttonContainer}>
            <Button 
              onPress={this.onNormalPress}
              title="正常模式"
              color="#841584"
              fontSize="20"
            />
          </View>
          <View style={styles.buttonContainer}>
            <Button 
              onPress={this.onPopupPress}
              title="弹窗模式"
              color="#841584"
              fontSize="20"
            />
          </View>
          <View style={styles.buttonContainer}>
            <Button 
              onPress={this.onFloatWindowPress}
              title="浮窗模式"
              color="#841584"
              fontSize="20"
            />
          </View>
          <View style={styles.buttonContainer}>
            <Button 
              onPress={this.onLandscapePress}
              title="横屏"
              color="#841584"
              fontSize="20"
            />
          </View>
        </View>  
      );
    }
}

const styles = StyleSheet.create({
    container: {
        flex: 1,
        justifyContent: 'center',
        alignItems: 'center',
        backgroundColor: '#39ffd6',
    },
    welcome: {
        fontSize: 20,
        textAlign: 'center',
        margin: 10,
    },
    ioscontainer: {
        flex: 1,
        justifyContent: 'flex-start',
    },
    buttonContainer: {
        margin: 20
    },
    button: {
        textAlign: 'left',
        marginLeft: 20,
        color: Colors.black,
        fontSize : 20
    },
    navigationBar: {
        backgroundColor: "#FF6600",
        height: 64,
        justifyContent: "center"
    },
    navigationTitle: {
        color: "#FFFFFF",
        fontSize: 17,
        textAlign: "center",
        justifyContent: "center"
    }
});

