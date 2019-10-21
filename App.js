/**
 * 极验OneLogin展示页面
 */
import React, {Component} from 'react';
import {
    StyleSheet,
    View,
    TouchableOpacity,
    Text,
} from 'react-native';
import onelogin from './src/onelogin';
import Orientation from 'react-native-orientation';

const onPressButton = () => {
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

    /**
     * 在组件绘制完成之后,设置屏幕方向为竖屏
     */
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
    }
});

