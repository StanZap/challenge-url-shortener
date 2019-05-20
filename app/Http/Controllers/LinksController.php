<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Link;
use Hashids\Hashids;
use Illuminate\Validation\ValidationException;

class LinksController extends Controller
{

    public function getTop100() {
        return Link::all()
            ->sortByDesc('views')
            ->take(100)
            ->map(function($link) {
                return [
                    'short_url' => url($link->hash),
                    'url' => $link->url,
                    'views' => (int) $link->views
                ];
            });
    }

    public function create(Request $request) {
        try {
            $request->validate([
                'link' => 'required|regex:/^(https?:\/\/)?([\da-z\.-]+)\.([a-z\.]{2,6})([\/\w \.-]*)*\/?$/'
            ]);

            $link = new Link([
                'url' => $request->get('link')
            ]);

            $link->save();
            $hashids = new Hashids();
            $link->hash = $hashids->encode($link->id);
            $link->save();

            return [
                'short_url' => url($link->hash),
            ];
        } catch (ValidationException $exception) {
            return response()->json([
                'error' => [
                    'message' => $exception->getMessage(),
                    'code' => 422
                ]
            ]);
        }
    }

    public function goTo($hash) {
        $link = Link::where(['hash' => $hash])->firstOrFail();
        $link->views++;
        $link->save();
        return redirect($link->url);
    }
}
