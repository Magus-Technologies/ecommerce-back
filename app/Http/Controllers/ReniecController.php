<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Http;

class ReniecController extends Controller
{
    public function buscar($doc)
    {
        $token = env('RENIEC_API_TOKEN');

        if (strlen($doc) == 8) {
            $url = 'https://dniruc.apisperu.com/api/v1/dni/' . $doc . '?token=' . $token;
        } else {
            $url = 'https://dniruc.apisperu.com/api/v1/ruc/' . $doc . '?token=' . $token;
        }

        $response = Http::get($url);

        if ($response->successful()) {
            $data = $response->json();

            if (strlen($doc) == 8) {
                $data["nombre"] = $data["nombres"] . " " . $data["apellidoPaterno"] . " " . $data["apellidoMaterno"];
            } else {
                $data["nombre"] = $data["razonSocial"];
            }

            return response()->json($data);
        } else {
            return response()->json([
                'message' => 'No se pudo obtener la información del documento',
                'status' => $response->status()
            ], $response->status());
        }
    }
}
