<?php

if(!defined('VESTA_CMD')) {
    die('No direct access allowed');
}

class Hook {
    private $filters = [];
    
    public function add_filter($callback, $priority = 1) {
        $this->filters[] = [
            'function' => $callback, 
            'priority' => $priority
        ];
        
        usort($this->filters, function ($a, $b) {
            return $a["priority"] - $b["priority"];
        });
    }
    
    public function do_action($args) {
        foreach($this->filters as $filterCallback) {
            if(is_array($args)) {
                call_user_func_array($filterCallback['function'], $args);
            }
            else {
                call_user_func_array($filterCallback['function'], array());
            }
        }
    }
}