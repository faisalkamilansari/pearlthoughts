<?php

namespace app\controllers;

use yii\web\Controller;
use yii\web\Response;

class HealthController extends Controller
{
    public $enableCsrfValidation = false;

    public function actionIndex()
    {
        \Yii::$app->response->format = Response::FORMAT_JSON;
        return ['status' => 'ok'];
    }
}
